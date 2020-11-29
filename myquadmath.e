-- Copyright (c) 2020 James J. Cook
-- A wrapper for myquadmath.dll / myquadmath.so

-- Some functions are included for convience to start a software library.

namespace myquad

ifdef DEBUG then
without trace
end ifdef

public include std/dll.e
public include std/machine.e
public include std/types.e

ifdef DEBUG then
with trace
end ifdef

public type cdatatype(sequence addresss_and_size)
	if length(addresss_and_size) = 2 then
		if atom(addresss_and_size[1]) then
			if integer(addresss_and_size[2]) then
				if addresss_and_size[2] >= 0 then
					return 1
				end if
			end if
		end if
	end if
	return 0
end type

public function new(object x = {}, integer size = 0)
	atom dst
	if atom(x) then
		dst = allocate_data(size)
		mem_copy(dst, x, size)
	elsif length(x) = 0 then
		dst = allocate_data(size)
	elsif string(x) then
		size = length(x) + 1
		dst = allocate_string(x)
	elsif length(x[1]) = size then
		dst = allocate_data(size)
		poke(dst, x[1])
	elsif length(x[1]) = 2 and size = 0 then
		x = x[1]
		for i = 1 to length(x[1]) do
			size += x[2][i]
		end for
		dst = allocate_data(size)
		poke(dst, x[1][1])
		for i = 2 to length(x[1]) do
			poke(dst + x[2][i-1], x[1][i])
		end for
	end if
	return dst
end function

public function new_c(object x = {}, integer size = 0)
	atom ma
	cdatatype r
	ma = new(x, size)
	if length(x[1]) = 2 and size = 0 then
		x = x[1]
		for i = 1 to length(x[1]) do
			size += x[2][i]
		end for
	end if
	r = {ma, size}
	return r
end function

ifdef BITS64 then
public function my_new_longlongint(atom i)
	atom ma
	ma = allocate_data(8)
	poke8(ma, i)
	return ma
end function
public function my_new_int128(atom low, atom high)
-- remember this number is little-endian.
	atom ma
	ma = allocate_data(16)
	poke8(ma, {low, high})
	return ma
end function

elsedef
public function my_new_longlongint(atom ilow, atom ihigh)
	atom ma
	ma = allocate_data(8)
	poke4(ma, {ilow, ihigh})
	return ma
end function
public function my_new_int128(atom llow, atom lhigh, atom hlow, atom hhigh)
-- remember this number is little-endian.
	atom ma
	ma = allocate_data(16)
	poke4(ma, {llow, lhigh, hlow, hhigh})
	return ma
end function

end ifdef


public atom libmyquadmath

ifdef WINDOWS then
	libmyquadmath = open_dll("libmyquadmath.dll")
	if libmyquadmath = 0 then
		puts(1, "Could not open libmyquadmath.dll\n")
	end if
elsedef
	libmyquadmath = open_dll("libmyquadmath.so")
	if libmyquadmath = 0 then
		puts(1, "Could not open libmyquadmath.so\n")
	end if
end ifdef

public constant
 myquadmath_snprintf = define_c_func(libmyquadmath, "myquadmath_snprintf",
	{C_POINTER, C_UINT, C_POINTER}, C_INT)
,mystrtoflt128 = define_c_proc(libmyquadmath, "mystrtoflt128",
	{C_POINTER, C_POINTER})

public function strtoflt128(string s)
	atom new_ma, str
	new_ma = allocate_data(16)
	str = allocate_string(s)
	c_proc(mystrtoflt128, {new_ma, str})
	free(str)
	return new_ma
end function
public function my_new_float128(string st = {})
	atom ma, str
	ma = allocate_data(16)
	if length(st) then
		str = allocate_string(st)
		c_proc(mystrtoflt128, {ma, str})
		free(str)
	else
		mem_set(ma, 0, 16)
	end if
	return ma
end function
public function my_new_complex128(string real = {}, string imag = {})
	atom cma, str
	cma = allocate_data(32)
	if length(real) then
		str = allocate_string(real)
		c_proc(mystrtoflt128, {cma, str})
		free(str)
	else
		mem_set(cma, 0, 16)
	end if
	if length(imag) then
		str = allocate_string(imag)
		c_proc(mystrtoflt128, {cma + 16, str})
		free(str)
	else
		mem_set(cma + 16, 0, 16)
	end if
	return cma
end function

public function quadmath_snprintf(atom ma)
	atom buf, tmp
	string s
	buf = allocate_data(128)
	tmp = c_func(myquadmath_snprintf, {buf, 128, ma})
	if tmp >= 128 then
		free(buf)
		return {}
	end if
	s = peek_string(buf)
	free(buf)
	return s
end function
public function my_float128_to_string(atom ma)
	return quadmath_snprintf(ma)
end function
public function my_complex128_to_string(atom cma)
	string st
	st = sprintf("{%s, %s i}", {float128_to_string(cma), float128_to_string(cma + 16)})
	return st
end function

public atom dst, m1, m2
public atom cdst, cm1, cm2

procedure init()
	dst = my_new_float128() -- destination __float128 buffer
	
	cdst = my_new_complex128() -- destination __complex128 buffer
end procedure
init()


public constant
--// The following macros are defined, which give the numeric limits of the __float128 data type.
 get_FLT128_MAX = define_c_proc(libmyquadmath, "get_FLT128_MAX", {C_POINTER})
,get_FLT128_MIN = define_c_proc(libmyquadmath, "get_FLT128_MIN", {C_POINTER})
,get_FLT128_EPSILON = define_c_proc(libmyquadmath, "get_FLT128_EPSILON", {C_POINTER})
,get_FLT128_DENORM_MIN = define_c_proc(libmyquadmath, "get_FLT128_DENORM_MIN", {C_POINTER})
,get_FLT128_MANT_DIG = define_c_proc(libmyquadmath, "get_FLT128_MANT_DIG", {C_POINTER})
,get_FLT128_MIN_EXP = define_c_proc(libmyquadmath, "get_FLT128_MIN_EXP", {C_POINTER})
,get_FLT128_MAX_EXP = define_c_proc(libmyquadmath, "get_FLT128_MAX_EXP", {C_POINTER})
,get_FLT128_DIG = define_c_proc(libmyquadmath, "get_FLT128_DIG", {C_POINTER})
,get_FLT128_MIN_10_EXP = define_c_proc(libmyquadmath, "get_FLT128_MIN_10_EXP", {C_POINTER})
,get_FLT128_MAX_10_EXP = define_c_proc(libmyquadmath, "get_FLT128_MAX_10_EXP", {C_POINTER})



--// The following mathematical constants of type __float128 are defined. 
,get_M_Eq = define_c_proc(libmyquadmath, "get_M_Eq", {C_POINTER})
,get_M_LOG2Eq = define_c_proc(libmyquadmath, "get_M_LOG2Eq", {C_POINTER})
,get_M_LOG10Eq = define_c_proc(libmyquadmath, "get_M_LOG10Eq", {C_POINTER})
,get_M_LN2q = define_c_proc(libmyquadmath, "get_M_LN2q", {C_POINTER})
,get_M_LN10q = define_c_proc(libmyquadmath, "get_M_LN10q", {C_POINTER})
,get_M_PIq = define_c_proc(libmyquadmath, "get_M_PIq", {C_POINTER})
,get_M_PI_2q = define_c_proc(libmyquadmath, "get_M_PI_2q", {C_POINTER})
,get_M_PI_4q = define_c_proc(libmyquadmath, "get_M_PI_4q", {C_POINTER})
,get_M_1_PIq = define_c_proc(libmyquadmath, "get_M_1_PIq", {C_POINTER})
,get_M_2_PIq = define_c_proc(libmyquadmath, "get_M_2_PIq", {C_POINTER})
,get_M_2_SQRTPIq = define_c_proc(libmyquadmath, "get_M_2_SQRTPIq", {C_POINTER})
,get_M_SQRT2q = define_c_proc(libmyquadmath, "get_M_SQRT2q", {C_POINTER})
,get_M_SQRT1_2q = define_c_proc(libmyquadmath, "get_M_SQRT1_2q", {C_POINTER})





public constant

 myacosq = define_c_proc(libmyquadmath, "myacosq", {C_POINTER, C_POINTER})
,myacoshq = define_c_proc(libmyquadmath, "myacoshq", {C_POINTER, C_POINTER})
,myasinq = define_c_proc(libmyquadmath, "myasinq", {C_POINTER, C_POINTER})
,myasinhq = define_c_proc(libmyquadmath, "myasinhq", {C_POINTER, C_POINTER})
,myatanq = define_c_proc(libmyquadmath, "myatanq", {C_POINTER, C_POINTER})
,myatanhq = define_c_proc(libmyquadmath, "myatanhq", {C_POINTER, C_POINTER})
,myatan2q = define_c_proc(libmyquadmath, "myatan2q", {C_POINTER, C_POINTER, C_POINTER})
,mycbrtq = define_c_proc(libmyquadmath, "mycbrtq", {C_POINTER, C_POINTER})
,myceilq = define_c_proc(libmyquadmath, "myceilq", {C_POINTER, C_POINTER})
,mycopysignq = define_c_proc(libmyquadmath, "mycopysignq", {C_POINTER, C_POINTER, C_POINTER})
,mycoshq = define_c_proc(libmyquadmath, "mycoshq", {C_POINTER, C_POINTER})
,mycosq = define_c_proc(libmyquadmath, "mycosq", {C_POINTER, C_POINTER})
,myerfq = define_c_proc(libmyquadmath, "myerfq", {C_POINTER, C_POINTER})
,myerfcq = define_c_proc(libmyquadmath, "myerfcq", {C_POINTER, C_POINTER})
,myexpq = define_c_proc(libmyquadmath, "myexpq", {C_POINTER, C_POINTER})
,myexpm1q = define_c_proc(libmyquadmath, "myexpm1q", {C_POINTER, C_POINTER})
,myfabsq = define_c_proc(libmyquadmath, "myfabsq", {C_POINTER, C_POINTER})
,myfdimq = define_c_proc(libmyquadmath, "myfdimq", {C_POINTER, C_POINTER, C_POINTER})
,myfiniteq = define_c_func(libmyquadmath, "myfiniteq", {C_POINTER}, C_INT)
,myfloorq = define_c_proc(libmyquadmath, "myfloorq", {C_POINTER, C_POINTER})

,myfmaq = define_c_proc(libmyquadmath, "myfmaq", {C_POINTER, C_POINTER, C_POINTER, C_POINTER})
,myfmaxq = define_c_proc(libmyquadmath, "myfmaxq", {C_POINTER, C_POINTER, C_POINTER})
,myfminq = define_c_proc(libmyquadmath, "myfminq", {C_POINTER, C_POINTER, C_POINTER})
,myfmodq = define_c_proc(libmyquadmath, "myfmodq", {C_POINTER, C_POINTER, C_POINTER})
,myfrexpq = define_c_proc(libmyquadmath, "myfrexpq", {C_POINTER, C_POINTER, C_POINTER})
,myhypotq = define_c_proc(libmyquadmath, "myhypotq", {C_POINTER, C_POINTER, C_POINTER})

,myisinfq = define_c_func(libmyquadmath, "myisinfq", {C_POINTER}, C_INT)
,myilogbq = define_c_func(libmyquadmath, "myilogbq", {C_POINTER}, C_INT)
,myisnanq = define_c_func(libmyquadmath, "myisnanq", {C_POINTER}, C_INT)

,myj0q = define_c_proc(libmyquadmath, "myj0q", {C_POINTER, C_POINTER})
,myj1q = define_c_proc(libmyquadmath, "myj1q", {C_POINTER, C_POINTER})

,myjnq = define_c_proc(libmyquadmath, "myjnq", {C_POINTER, C_INT, C_POINTER})
,myldexpq = define_c_proc(libmyquadmath, "myldexpq", {C_POINTER, C_POINTER, C_UINT})

,mylgammaq = define_c_proc(libmyquadmath, "mylgammaq", {C_POINTER, C_POINTER})

--//extern long long int llrintq (__float128) __quadmath_throw;
--void myllrintq(unsigned int *out1, unsigned int *arg1)
,myllrintq = define_c_proc(libmyquadmath, "myllrintq", {C_POINTER, C_POINTER})

--//extern long long int llroundq (__float128) __quadmath_throw;
--void myllroundq(unsigned int *out1, unsigned int *arg1)
,myllroundq = define_c_proc(libmyquadmath, "myllroundq", {C_POINTER, C_POINTER})

,mylogq = define_c_proc(libmyquadmath, "mylogq", {C_POINTER, C_POINTER})
,mylog10q = define_c_proc(libmyquadmath, "mylog10q", {C_POINTER, C_POINTER})
,mylog2q = define_c_proc(libmyquadmath, "mylog2q", {C_POINTER, C_POINTER})
,mylog1pq = define_c_proc(libmyquadmath, "mylog1pq", {C_POINTER, C_POINTER})

-- //extern long int lrintq (__float128) __quadmath_throw;
-- extern long int mylrintq(unsigned int *arg1);
,mylrintq = define_c_func(libmyquadmath, "mylrintq", {C_POINTER}, C_LONG)

-- //extern long int lroundq (__float128) __quadmath_throw;
-- extern long int mylroundq(unsigned int *arg1);
,mylroundq = define_c_func(libmyquadmath, "mylroundq", {C_POINTER}, C_LONG)

,mymodfq = define_c_proc(libmyquadmath, "mymodfq", {C_POINTER, C_POINTER, C_POINTER})

-- //extern __float128 nanq (const char *) __quadmath_throw;
-- void mynanq(unsigned int *dst, const char *str)
,mynanq = define_c_proc(libmyquadmath, "mynanq", {C_POINTER, C_POINTER})

,mynearbyintq = define_c_proc(libmyquadmath, "mynearbyintq", {C_POINTER, C_POINTER})
,mynextafterq = define_c_proc(libmyquadmath, "mynextafterq", {C_POINTER, C_POINTER, C_POINTER})
,mypowq = define_c_proc(libmyquadmath, "mypowq", {C_POINTER, C_POINTER, C_POINTER})
,myremainderq = define_c_proc(libmyquadmath, "myremainderq", {C_POINTER, C_POINTER, C_POINTER})
,myremquoq = define_c_proc(libmyquadmath, "myremquoq", {C_POINTER, C_POINTER, C_POINTER, C_POINTER})

,myrintq = define_c_proc(libmyquadmath, "myrintq", {C_POINTER, C_POINTER})
,myroundq = define_c_proc(libmyquadmath, "myroundq", {C_POINTER, C_POINTER})

,myscalblnq = define_c_proc(libmyquadmath, "myscalblnq", {C_POINTER, C_POINTER, C_LONG})
,myscalbnq = define_c_proc(libmyquadmath, "myscalbnq", {C_POINTER, C_POINTER, C_INT})

,mysignbitq = define_c_func(libmyquadmath, "mysignbitq", {C_POINTER}, C_INT)

-- //extern void sincosq (__float128, __float128 *, __float128 *) __quadmath_throw;
-- void mysincosq(unsigned int *arg1, unsigned int *dst1, unsigned *dst2)
,mysincosq = define_c_proc(libmyquadmath, "mysincosq", {C_POINTER, C_POINTER, C_POINTER})

,mysinhq = define_c_proc(libmyquadmath, "mysinhq", {C_POINTER, C_POINTER})
,mysinq = define_c_proc(libmyquadmath, "mysinq", {C_POINTER, C_POINTER})
,mysqrtq = define_c_proc(libmyquadmath, "mysqrtq", {C_POINTER, C_POINTER})
,mytanq = define_c_proc(libmyquadmath, "mytanq", {C_POINTER, C_POINTER})
,mytanhq = define_c_proc(libmyquadmath, "mytanhq", {C_POINTER, C_POINTER})
,mytgammaq = define_c_proc(libmyquadmath, "mytgammaq", {C_POINTER, C_POINTER})
,mytruncq = define_c_proc(libmyquadmath, "mytruncq", {C_POINTER, C_POINTER})
,myy0q = define_c_proc(libmyquadmath, "myy0q", {C_POINTER, C_POINTER})
,myy1q = define_c_proc(libmyquadmath, "myy1q", {C_POINTER, C_POINTER})

,myynq = define_c_proc(libmyquadmath, "myynq", {C_POINTER, C_INT, C_POINTER})


,_addq = define_c_proc(libmyquadmath, "addq", {C_POINTER, C_POINTER, C_POINTER})
,_divideq = define_c_proc(libmyquadmath, "divideq", {C_POINTER, C_POINTER, C_POINTER})
,_multq = define_c_proc(libmyquadmath, "multq", {C_POINTER, C_POINTER, C_POINTER})
,_subtractq = define_c_proc(libmyquadmath, "subtractq", {C_POINTER, C_POINTER, C_POINTER})

public function my_addq(atom m1, atom m2)
	c_proc(_addq, {dst, m1, m2})
	return new(dst, 16)
end function
public function my_subtractq(atom m1, atom m2)
	c_proc(_subtractq, {dst, m1, m2})
	return new(dst, 16)
end function
public function my_multq(atom m1, atom m2)
	c_proc(_multq, {dst, m1, m2})
	return new(dst, 16)
end function
public function my_divideq(atom m1, atom m2)
	c_proc(_divideq, {dst, m1, m2})
	return new(dst, 16)
end function

-- Complex function support:

public constant

--// These return a __float128 in *dst, but take a __complex128 in *arg1

 mycabsq = define_c_proc(libmyquadmath, "mycabsq", {C_POINTER, C_POINTER})
,mycargq = define_c_proc(libmyquadmath, "mycargq", {C_POINTER, C_POINTER})
,mycimagq = define_c_proc(libmyquadmath, "mycimagq", {C_POINTER, C_POINTER})
,mycrealq = define_c_proc(libmyquadmath, "mycrealq", {C_POINTER, C_POINTER})

--// These *dst represent __complex128, which are two __float128's.

,get_Complex_I = define_c_proc(libmyquadmath, "get_Complex_I", {C_POINTER})

,mycacosq = define_c_proc(libmyquadmath, "mycacosq", {C_POINTER, C_POINTER})
,mycacoshq = define_c_proc(libmyquadmath, "mycacoshq", {C_POINTER, C_POINTER})
,mycasinq = define_c_proc(libmyquadmath, "mycasinq", {C_POINTER, C_POINTER})
,mycasinhq = define_c_proc(libmyquadmath, "mycasinhq", {C_POINTER, C_POINTER})
,mycatanq = define_c_proc(libmyquadmath, "mycatanq", {C_POINTER, C_POINTER})
,mycatanhq = define_c_proc(libmyquadmath, "mycatanhq", {C_POINTER, C_POINTER})
,myccosq = define_c_proc(libmyquadmath, "myccosq", {C_POINTER, C_POINTER})
,myccoshq = define_c_proc(libmyquadmath, "myccoshq", {C_POINTER, C_POINTER})
,mycexpq = define_c_proc(libmyquadmath, "mycexpq", {C_POINTER, C_POINTER})
,mycexpiq = define_c_proc(libmyquadmath, "mycexpiq", {C_POINTER, C_POINTER})
,myclogq = define_c_proc(libmyquadmath, "myclogq", {C_POINTER, C_POINTER})
,myclog10q = define_c_proc(libmyquadmath, "myclog10q", {C_POINTER, C_POINTER})
,myconjq = define_c_proc(libmyquadmath, "myconjq", {C_POINTER, C_POINTER})

,mycpowq = define_c_proc(libmyquadmath, "mycpowq", {C_POINTER, C_POINTER, C_POINTER})

,mycprojq = define_c_proc(libmyquadmath, "mycprojq", {C_POINTER, C_POINTER})
,mycsinq = define_c_proc(libmyquadmath, "mycsinq", {C_POINTER, C_POINTER})
,mycsinhq = define_c_proc(libmyquadmath, "mycsinhq", {C_POINTER, C_POINTER})
,mycsqrtq = define_c_proc(libmyquadmath, "mycsqrtq", {C_POINTER, C_POINTER})
,myctanq = define_c_proc(libmyquadmath, "myctanq", {C_POINTER, C_POINTER})
,myctanhq = define_c_proc(libmyquadmath, "myctanhq", {C_POINTER, C_POINTER})

,_caddq = define_c_proc(libmyquadmath, "caddq", {C_POINTER, C_POINTER, C_POINTER})
,_cdivideq = define_c_proc(libmyquadmath, "cdivideq", {C_POINTER, C_POINTER, C_POINTER})
,_cmultq = define_c_proc(libmyquadmath, "cmultq", {C_POINTER, C_POINTER, C_POINTER})
,_csubtractq = define_c_proc(libmyquadmath, "csubtractq", {C_POINTER, C_POINTER, C_POINTER})



public function my_caddq(atom cm1, atom cm2)
	c_proc(_caddq, {cdst, cm1, cm2})
	return new(cdst, 32)
end function
public function my_csubtractq(atom cm1, atom cm2)
	c_proc(_csubtractq, {cdst, cm1, cm2})
	return new(cdst, 32)
end function
public function my_cmultq(atom cm1, atom cm2)
	c_proc(_cmultq, {cdst, cm1, cm2})
	return new(cdst, 32)
end function
public function my_cdivideq(atom cm1, atom cm2)
	c_proc(_cdivideq, {cdst, cm1, cm2})
	return new(cdst, 32)
end function


-- Compare functions:


public constant
 _compareq = define_c_func(libmyquadmath, "compareq", {C_POINTER, C_POINTER}, C_INT)

-------------------------------------------------------------------------------
-- equadmath.e functions:
-------------------------------------------------------------------------------

-- public type cstring(cdatatype s)
-- 	--if string(peek_string(s[1])) then
-- 		return 1
-- 	--end if
-- 	--return 0
-- end type

public function new_cstring(string s)
	atom ma
	ma = allocate_string(s)
	return {ma, length(s) + 1} -- allocate_string allocates length(s) + 1, for last zero (0)
end function


public constant sizeof_float128 = 16

public type int128(cdatatype i) return i[2] = 16 end type
public type float128(cdatatype f) return f[2] = 16 end type
public type complex128(cdatatype c) return c[2] = 32 end type
public type longlongint(cdatatype i) return i[2] = 8 end type

public type struct(cdatatype x)
	return 1
end type

public type seq_of_float128(sequence s)
	for i = 1 to length(s) do
		if not float128(s[i]) then
			return 0
		end if
	end for
	return 1
end type
public type seq_of_complex128(sequence s)
	for i = 1 to length(s) do
		if not complex128(s[i]) then
			return 0
		end if
	end for
	return 1
end type

ifdef BITS64 then
public function new_longlongint(atom i) return {my_new_longlongint(i), 8} end function
public function new_int128(atom low, atom high) return {my_new_int128(low, high), 16} end function
elsedef
public function new_longlongint(atom ilow, atom ihigh) return {my_new_longlongint(ilow, ihigh), 8} end function
public function new_int128(atom llow, atom lhigh, atom hlow, atom hhigh) return {my_new_int128(llow, lhigh, hlow, hhigh), 16} end function
end ifdef

public function new_float128(string st = {}) return {my_new_float128(st), 16} end function
public function new_complex128(string real = {}, string imag = {}) return {my_new_complex128(real, imag), 32} end function

public function float128_to_string(float128 f) return my_float128_to_string(f[1]) end function
public function complex128_to_string(complex128 c) return my_complex128_to_string(c[1]) end function

public function copy(struct dst, struct src)
	if dst[2] = src[2] then
		mem_copy(dst[1], src[1], dst[2])
		return dst[2]
	end if
	return 0
end function

public function copy_to_complex128(complex128 dst, float128 real, float128 imag)
	mem_copy(dst[1], real[1], real[2])
	mem_copy(dst[1]+real[2], imag[1], imag[2])
	return dst[2]
end function

public procedure copy_to_real128(float128 real, complex128 src)
	mem_copy(real[1], src[1], real[2])
end procedure
public procedure copy_to_imag128(float128 imag, complex128 src)
	mem_copy(imag[1], src[1]+sizeof_float128, imag[2])
end procedure

public function get_real_imag128(complex128 src)
	float128 real, imag
	real = new_float128()
	imag = new_float128()
	copy_to_real128(real, src)
	copy_to_imag128(imag, src)
	return {real, imag}
end function


public function compare_float128(float128 a, float128 b)
	return c_func(_compareq, {a[1], b[1]})
end function



function func1(atom proc, float128 f1)
	atom ma
	ma = allocate_data(16)
	c_proc(proc, {ma, f1[1]})
	return {ma, 16}
end function
function func2(atom proc, float128 f1, float128 f2)
	atom ma
	ma = allocate_data(16)
	c_proc(proc, {ma, f1[1], f2[1]})
	return {ma, 16}
end function
function cfunc1(atom cproc, complex128 c1)
	atom ma
	ma = allocate_data(32)
	c_proc(cproc, {ma, c1[1]})
	return {ma, 32}
end function
function cfunc2(atom cproc, complex128 c1, complex128 c2)
	atom ma
	ma = allocate_data(32)
	c_proc(cproc, {ma, c1[1], c2[1]})
	return {ma, 32}
end function

public function addq(float128 f1, float128 f2) return func2(_addq, f1, f2) end function
public function subtractq(float128 f1, float128 f2) return func2(_subtractq, f1, f2) end function
public function multq(float128 f1, float128 f2) return func2(_multq, f1, f2) end function
public function divideq(float128 f1, float128 f2) return func2(_divideq, f1, f2) end function

public function caddq(complex128 c1, complex128 c2) return cfunc2(_caddq, c1, c2) end function
public function csubtractq(complex128 c1, complex128 c2) return cfunc2(_csubtractq, c1, c2) end function
public function cmultq(complex128 c1, complex128 c2) return cfunc2(_cmultq, c1, c2) end function
public function cdivideq(complex128 c1, complex128 c2) return cfunc2(_cdivideq, c1, c2) end function

-- sequence var = new_complex128("0.0","1.0e1000")
-- sequence ans
-- 
-- printf(1, "Complex is:\n%s\n", {complex128_to_string(var)})
-- 
-- ans = cmultq(var, var)
-- 
-- printf(1, "Times its self:\n%s\n", {complex128_to_string(ans)})


-- get constants:

function get_constant(atom cproc)
	atom ma
	ma = allocate_data(16)
	c_proc(cproc, {ma})
	return {ma, 16}
end function

public sequence
 FLT128_MAX
,FLT128_MIN
,FLT128_EPSILON
,FLT128_DENORM_MIN
,FLT128_MANT_DIG
,FLT128_MIN_EXP
,FLT128_MAX_EXP
,FLT128_DIG
,FLT128_MIN_10_EXP
,FLT128_MAX_10_EXP

,M_Eq
,M_LOG2Eq
,M_LOG10Eq
,M_LN2q
,M_LN10q
,M_PIq
,M_PI_2q
,M_PI_4q
,M_1_PIq
,M_2_PIq
,M_2_SQRTPIq
,M_SQRT2q
,M_SQRT1_2q

,Complex_I

function get_complex_constant(atom cproc)
	atom ma
	ma = allocate_data(32) -- only for complex numbers
	c_proc(cproc, {ma})
	return {ma, 32} -- only for complex numbers
end function

public procedure init_constants()
	FLT128_MAX = get_constant(get_FLT128_MAX)
	FLT128_MIN = get_constant(get_FLT128_MIN)
	FLT128_EPSILON = get_constant(get_FLT128_EPSILON)
	FLT128_DENORM_MIN = get_constant(get_FLT128_DENORM_MIN)
	FLT128_MANT_DIG = get_constant(get_FLT128_MANT_DIG)
	FLT128_MIN_EXP = get_constant(get_FLT128_MIN_EXP)
	FLT128_MAX_EXP = get_constant(get_FLT128_MAX_EXP)
	FLT128_DIG = get_constant(get_FLT128_DIG)
	FLT128_MIN_10_EXP = get_constant(get_FLT128_MIN_10_EXP)
	FLT128_MAX_10_EXP = get_constant(get_FLT128_MAX_10_EXP)
	
	M_Eq = get_constant(get_M_Eq)
	M_LOG2Eq = get_constant(get_M_LOG2Eq)
	M_LOG10Eq = get_constant(get_M_LOG10Eq)
	M_LN2q = get_constant(get_M_LN2q)
	M_LN10q = get_constant(get_M_LN10q)
	M_PIq = get_constant(get_M_PIq)
	M_PI_2q = get_constant(get_M_PI_2q)
	M_PI_4q = get_constant(get_M_PI_4q)
	M_1_PIq = get_constant(get_M_1_PIq)
	M_2_PIq = get_constant(get_M_2_PIq)
	M_2_SQRTPIq = get_constant(get_M_2_SQRTPIq)
	M_SQRT2q = get_constant(get_M_SQRT2q)
	M_SQRT1_2q = get_constant(get_M_SQRT1_2q)

	Complex_I = get_complex_constant(get_Complex_I)
end procedure
--init_constants()

-- float128 functions:
public function acosq(float128 f1) return func1(myacosq, f1) end function
public function acoshq(float128 f1) return func1(myacoshq, f1) end function
public function asinq(float128 f1) return func1(myasinq, f1) end function
public function asinhq(float128 f1) return func1(myasinhq, f1) end function
public function atanq(float128 f1) return func1(myatanq, f1) end function
public function atanhq(float128 f1) return func1(myatanhq, f1) end function

public function atan2q(float128 f1, float128 f2) return func2(myatan2q, f1, f2) end function

public function cbrtq(float128 f1) return func1(mycbrtq, f1) end function
public function ceilq(float128 f1) return func1(myceilq, f1) end function

public function copysignq(float128 f1, float128 f2) return func2(mycopysignq, f1, f2) end function

public function coshq(float128 f1) return func1(mycoshq, f1) end function
public function cosq(float128 f1) return func1(mycosq, f1) end function
public function erfq(float128 f1) return func1(myerfq, f1) end function
public function erfcq(float128 f1) return func1(myerfcq, f1) end function
public function expq(float128 f1) return func1(myexpq, f1) end function
public function expm1q(float128 f1) return func1(myexpm1q, f1) end function
public function fabsq(float128 f1) return func1(myfabsq, f1) end function

public function fdimq(float128 f1, float128 f2) return func2(myfdimq, f1, f2) end function

public function finiteq(float128 f1)
	return c_func(myfiniteq, {f1[1]})
end function

public function floorq(float128 f1) return func1(myfloorq, f1) end function

public function fmaq(float128 f1, float128 f2, float128 f3)
	atom ma
	ma = allocate_data(16)
	c_proc(myfmaq, {ma, f1[1], f2[1], f3[1]})
	return {ma, 16}
end function

public function fmaxq(float128 f1, float128 f2) return func2(myfmaxq, f1, f2) end function
public function fminq(float128 f1, float128 f2) return func2(myfminq, f1, f2) end function
public function fmodq(float128 f1, float128 f2) return func2(myfmodq, f1, f2) end function
public function frexpq(float128 f1, float128 f2) return func2(myfrexpq, f1, f2) end function
public function hypotq(float128 f1, float128 f2) return func2(myhypotq, f1, f2) end function

public function isinfq(float128 f1)
	return c_func(myisinfq, {f1[1]})
end function
public function ilogbq(float128 f1)
	return c_func(myilogbq, {f1[1]})
end function
public function isnanq(float128 f1)
	return c_func(myisnanq, {f1[1]})
end function

public function j0q(float128 f1) return func1(myj0q, f1) end function
public function j1q(float128 f1) return func1(myj1q, f1) end function

public function jnq(atom i1, float128 f2)
	atom ma
	ma = allocate_data(16)
	c_proc(myjnq, {ma, i1, f2[1]})
	return {ma, 16}
end function

public function ldexpq(float128 f1, atom i2)
	atom ma
	ma = allocate_data(16)
	c_proc(myldexpq, {ma, f1[1], i2})
	return {ma, 16}
end function

public function lgammaq(float128 f1) return func1(mylgammaq, f1) end function

public function llrintq(float128 f1)
--//extern long long int llrintq (__float128) __quadmath_throw;
--void myllrintq(unsigned int *out1, unsigned int *arg1)
	atom ma
	ma = allocate_data(8) -- out1
	c_proc(myllrintq, {ma, f1[1]})
	return {ma, 8}
end function

public function llroundq(float128 f1)
--//extern long long int llroundq (__float128) __quadmath_throw;
--void myllroundq(unsigned int *out1, unsigned int *arg1)
	atom ma
	ma = allocate_data(8) -- out1
	c_proc(myllroundq, {ma, f1[1]})
	return {ma, 8}
end function

public function logq(float128 f1) return func1(mylogq, f1) end function
public function log10q(float128 f1) return func1(mylog10q, f1) end function
public function log2q(float128 f1) return func1(mylog2q, f1) end function
public function log1pq(float128 f1) return func1(mylog1pq, f1) end function

public function lrintq(float128 f1)
-- //extern long int lrintq (__float128) __quadmath_throw;
-- extern long int mylrintq(unsigned int *arg1);
	return c_func(mylrintq, {f1[1]})
end function

public function lroundq(float128 f1)
-- //extern long int lroundq (__float128) __quadmath_throw;
-- extern long int mylroundq(unsigned int *arg1);
	return c_func(mylroundq, {f1[1]})
end function


public function modfq(float128 f1) -- returns two float128s as {frac, integral}
-- //extern __float128 modfq (__float128, __float128 *) __quadmath_throw;
-- void mymodfq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1, FLOAT128_UNION_PTR arg2)
-- {
--      dst->q = modfq(arg1->q, &arg2->q); // in2 is (__float128 *)
-- }
-- http://en.cppreference.com/w/cpp/numeric/math/modf
	float128 frac, integral
	atom ma, ma2
	ma = allocate_data(16)
	ma2 = allocate_data(16)
	c_proc(mymodfq, {ma, f1[1], ma2})
	frac = {ma, 16}
	integral = {ma2, 16}
	return {frac, integral}
end function


public function nanq(sequence s)
-- //extern __float128 nanq (const char *) __quadmath_throw;
-- void mynanq(unsigned int *dst, const char *str)
	atom ma
	ma = allocate_data(16)
	c_proc(mynanq, {ma, s[1]})
	return {ma, 16}
end function


public function nearbyintq(float128 f1) return func1(mynearbyintq, f1) end function
public function nextafterq(float128 f1, float128 f2) return func2(mynextafterq, f1, f2) end function
public function powq(float128 f1, float128 f2) return func2(mypowq, f1, f2) end function
public function remainderq(float128 f1, float128 f2) return func2(myremainderq, f1, f2) end function

public function remquoq(float128 f1, float128 f2, atom int_ptr)
-- //extern __float128 remquoq (__float128, __float128, int *) __quadmath_throw;
-- void myremquoq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1, FLOAT128_UNION_PTR arg2, int *iptr3)
-- {
--      dst->q = remquoq(arg1->q, arg2->q, iptr3);
-- }
	atom ma
	ma = allocate_data(16)
	c_proc(myremquoq, {ma, f1[1], f2[1], int_ptr})
	return {ma, 16}
end function

public function rintq(float128 f1) return func1(myrintq, f1) end function
public function roundq(float128 f1) return func1(myroundq, f1) end function


public function scalblnq(float128 f1, atom longint2)
-- //extern __float128 scalblnq (__float128, long int) __quadmath_throw;
-- void myscalblnq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1, long int i2)
-- {
--      dst->q = scalblnq(arg1->q, i2);
-- }
	atom ma
	ma = allocate_data(16)
	c_proc(myscalblnq, {ma, f1[1], longint2})
	return {ma, 16}
end function

public function scalbnq(float128 f1, atom int2)
-- //extern __float128 scalbnq (__float128, int) __quadmath_throw;
-- void myscalbnq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1, int i2)
-- {
--      dst->q = scalbnq(arg1->q, i2);
-- }
	atom ma
	ma = allocate_data(16)
	c_proc(myscalbnq, {ma, f1[1], int2})
	return {ma, 16}
end function

public function signbitq(float128 f1)
	atom int1
	int1 = c_func(mysignbitq, {f1[1]})
	return int1
end function


public function sincosq(float128 f1) -- returns two float128s
-- //extern void sincosq (__float128, __float128 *, __float128 *) __quadmath_throw;
-- void mysincosq(FLOAT128_UNION_PTR arg1, FLOAT128_UNION_PTR dst1, FLOAT128_UNION_PTR dst2)
-- {
--      sincosq(arg1->q, &dst1->q, &dst2->q);
-- }
	float128 a, b
	atom ma1, ma2
	ma1 = allocate_data(16)
	ma2 = allocate_data(16)
	c_proc(mysincosq, {f1[1], ma1, ma2})
	a = {ma1, 16}
	b = {ma2, 16}
	return {a, b}
end function

public function sinhq(float128 f1) return func1(mysinhq, f1) end function
public function sinq(float128 f1) return func1(mysinq, f1) end function
public function sqrtq(float128 f1) return func1(mysqrtq, f1) end function
public function tanq(float128 f1) return func1(mytanq, f1) end function
public function tanhq(float128 f1) return func1(mytanhq, f1) end function
public function tgammaq(float128 f1) return func1(mytgammaq, f1) end function
public function truncq(float128 f1) return func1(mytruncq, f1) end function
public function y0q(float128 f1) return func1(myy0q, f1) end function
public function y1q(float128 f1) return func1(myy1q, f1) end function

public function ynq(atom int1, float128 f2)
-- //extern __float128 ynq (int, __float128) __quadmath_throw;
-- void myynq(FLOAT128_UNION_PTR dst, int i1, FLOAT128_UNION_PTR arg2)
-- {
--      dst->q = ynq(i1, arg2->q);
-- }
	atom ma
	ma = allocate_data(16)
	c_proc(myynq, {ma, int1, f2[1]})
	return {ma, 16}
end function


--// These return a __float128 in *dst, but take a __complex128 in *arg1
public function cabsq(complex128 c1)
	atom ma
	ma = allocate_data(16) -- only for these complex functions
	c_proc(mycabsq, {ma, c1[1]})
	return {ma, 16} -- only for these complex functions
end function
public function cargq(complex128 c1)
	atom ma
	ma = allocate_data(16) -- only for these complex functions
	c_proc(mycargq, {ma, c1[1]})
	return {ma, 16} -- only for these complex functions
end function
public function cimagq(complex128 c1)
	atom ma
	ma = allocate_data(16) -- only for these complex functions
	c_proc(mycimagq, {ma, c1[1]})
	return {ma, 16} -- only for these complex functions
end function
public function crealq(complex128 c1)
	atom ma
	ma = allocate_data(16) -- only for these complex functions
	c_proc(mycrealq, {ma, c1[1]})
	return {ma, 16} -- only for these complex functions
end function

--// These *dst represent __complex128, which are two __float128's.

public function cacosq(complex128 c1) return cfunc1(mycacosq, c1) end function
public function cacoshq(complex128 c1) return cfunc1(mycacoshq, c1) end function
public function casinq(complex128 c1) return cfunc1(mycasinq, c1) end function
public function casinhq(complex128 c1) return cfunc1(mycasinhq, c1) end function
public function catanq(complex128 c1) return cfunc1(mycatanq, c1) end function
public function catanhq(complex128 c1) return cfunc1(mycatanhq, c1) end function
public function ccosq(complex128 c1) return cfunc1(myccosq, c1) end function
public function ccoshq(complex128 c1) return cfunc1(myccoshq, c1) end function
public function cexpq(complex128 c1) return cfunc1(mycexpq, c1) end function
public function cexpiq(complex128 c1) return cfunc1(mycexpiq, c1) end function
public function clogq(complex128 c1) return cfunc1(myclogq, c1) end function
public function clog10q(complex128 c1) return cfunc1(myclog10q, c1) end function
public function conjq(complex128 c1) return cfunc1(myconjq, c1) end function

public function cpowq(complex128 c1, complex128 c2) return cfunc2(mycpowq, c1, c2) end function
-- //extern __complex128 cpowq (__complex128, __complex128) __quadmath_throw;
-- void mycpowq(COMPLEX128_UNION_PTR cdst, COMPLEX128_UNION_PTR carg1, COMPLEX128_UNION_PTR carg2)
-- {
--      cdst->j = cpowq(carg1->j, carg2->j);
-- }

public function cprojq(complex128 c1) return cfunc1(mycprojq, c1) end function
public function csinq(complex128 c1) return cfunc1(mycsinq, c1) end function
public function csinhq(complex128 c1) return cfunc1(mycsinhq, c1) end function
public function csqrtq(complex128 c1) return cfunc1(mycsqrtq, c1) end function
public function ctanq(complex128 c1) return cfunc1(myctanq, c1) end function
public function ctanhq(complex128 c1) return cfunc1(myctanhq, c1) end function


-- end of file.
