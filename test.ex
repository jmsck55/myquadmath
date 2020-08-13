
--with define DEBUG

with trace

include myquadmath.e

trace(1)

int128 i128
float128 f128
complex128 c128
longlongint lli64

cdatatype buf
struct this_struct

seq_of_float128 many_float128s, tmp_float128s
seq_of_complex128 many_complex128s


init_constants()


i128 = new_int128(0,0,0,0)
f128 = new_float128("0.0e0")
c128 = new_complex128("0.0e0","1.0e0") -- complex_i
lli64 = new_longlongint(0,0)

buf = new_cstring("123.123e123")
this_struct = buf


many_float128s = get_real_imag128(c128)
tmp_float128s = get_real_imag128(Complex_I)

-- compare the real and imaginary parts:
? compare_float128(many_float128s[1], tmp_float128s[1]) -- real parts
? compare_float128(many_float128s[2], tmp_float128s[2]) -- imaginary parts


if copy(c128, Complex_I) = 0 then
	puts(1, "Could not copy to c128\n")
end if

printf(1, "%s\n", {float128_to_string(tmp_float128s[1])})
printf(1, "%s\n", {float128_to_string(tmp_float128s[2])})

