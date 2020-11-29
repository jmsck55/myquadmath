// Copyright (c) 2020 James J. Cook

#include <quadmath.h>
#include "myquadmath_dll.h"


// Added: int compareq(FLOAT128_UNION_PTR arg1, FLOAT128_UNION_PTR arg2)


// Use suffix q for quadmath float types, literals
// Use suffix qi or qj for quadmath complex types, literals

// example:
// __complex128 c = (2.0q + 1.0iq);
// or
// __float a = 2.0q;
// __complex128 c = 1.0iq;
// c = a + c;

int myquadmath_snprintf(char *s, size_t size, FLOAT128_UNION_PTR ptr)
{
	int prec = 33; // it has to be 33, for greater accuracy with float128.
	int width = 0;
	
	int n = quadmath_snprintf(s, size, "%+-#*.*Qe", width, prec, ptr->q);
	
	return n;
}
void mystrtoflt128(FLOAT128_UNION_PTR dst, const char *s) {dst->q = strtoflt128(s, NULL);}

// other functions for this header file (contained in quadmath.h)

// constants:
/*
The following macros are defined, which give the numeric limits of the __float128 data type. 
FLT128_MAX: largest finite number
FLT128_MIN: smallest positive number with full precision
FLT128_EPSILON: difference between 1 and the next larger
representable number 
FLT128_DENORM_MIN: smallest positive denormalized number
FLT128_MANT_DIG: number of digits in the mantissa (bit precision)
FLT128_MIN_EXP: maximal negative exponent
FLT128_MAX_EXP: maximal positive exponent
FLT128_DIG: number of decimal digits in the mantissa
FLT128_MIN_10_EXP: maximal negative decimal exponent
FLT128_MAX_10_EXP: maximal positive decimal exponent

The following mathematical constants of type __float128 are defined. 
M_Eq: the constant e (Euler's number)
M_LOG2Eq: binary logarithm of 2
M_LOG10Eq: common, decimal logarithm of 2
M_LN2q: natural logarithm of 2
M_LN10q: natural logarithm of 10
M_PIq: pi
M_PI_2q: pi divided by two
M_PI_4q: pi divided by four
M_1_PIq: one over pi
M_2_PIq: one over two pi
M_2_SQRTPIq: two over square root of pi
M_SQRT2q: square root of 2
M_SQRT1_2q: one over square root of 2
*/

/* Macros */
/*
#define FLT128_MAX 1.18973149535723176508575932662800702e4932Q
#define FLT128_MIN 3.36210314311209350626267781732175260e-4932Q
#define FLT128_EPSILON 1.92592994438723585305597794258492732e-34Q
#define FLT128_DENORM_MIN 6.475175119438025110924438958227646552e-4966Q
#define FLT128_MANT_DIG 113
#define FLT128_MIN_EXP (-16381)
#define FLT128_MAX_EXP 16384
#define FLT128_DIG 33
#define FLT128_MIN_10_EXP (-4931)
#define FLT128_MAX_10_EXP 4932
*/

#define get_constant(C,D) D->q = C;

// The following macros are defined, which give the numeric limits of the __float128 data type. 
void get_FLT128_MAX(FLOAT128_UNION_PTR dst) {dst->q = FLT128_MAX;}
void get_FLT128_MIN(FLOAT128_UNION_PTR dst) {dst->q = FLT128_MIN;}
void get_FLT128_EPSILON(FLOAT128_UNION_PTR dst) {dst->q = FLT128_EPSILON;}
void get_FLT128_DENORM_MIN(FLOAT128_UNION_PTR dst) {dst->q = FLT128_DENORM_MIN;}
void get_FLT128_MANT_DIG(FLOAT128_UNION_PTR dst) {dst->q = FLT128_MANT_DIG;}
void get_FLT128_MIN_EXP(FLOAT128_UNION_PTR dst) {dst->q = FLT128_MIN_EXP;}
void get_FLT128_MAX_EXP(FLOAT128_UNION_PTR dst) {dst->q = FLT128_MAX_EXP;}
void get_FLT128_DIG(FLOAT128_UNION_PTR dst) {dst->q = FLT128_DIG;}
void get_FLT128_MIN_10_EXP(FLOAT128_UNION_PTR dst) {dst->q = FLT128_MIN_10_EXP;}
void get_FLT128_MAX_10_EXP(FLOAT128_UNION_PTR dst) {dst->q = FLT128_MAX_10_EXP;}

// The following mathematical constants of type __float128 are defined. 
void get_M_Eq(FLOAT128_UNION_PTR dst) {dst->q = M_Eq;}
void get_M_LOG2Eq(FLOAT128_UNION_PTR dst) {dst->q = M_LOG2Eq;}
void get_M_LOG10Eq(FLOAT128_UNION_PTR dst) {dst->q = M_LOG10Eq;}
void get_M_LN2q(FLOAT128_UNION_PTR dst) {dst->q = M_LN2q;}
void get_M_LN10q(FLOAT128_UNION_PTR dst) {dst->q = M_LN10q;}
void get_M_PIq(FLOAT128_UNION_PTR dst) {dst->q = M_PIq;}
void get_M_PI_2q(FLOAT128_UNION_PTR dst) {dst->q = M_PI_2q;}
void get_M_PI_4q(FLOAT128_UNION_PTR dst) {dst->q = M_PI_4q;}
void get_M_1_PIq(FLOAT128_UNION_PTR dst) {dst->q = M_1_PIq;}
void get_M_2_PIq(FLOAT128_UNION_PTR dst) {dst->q = M_2_PIq;}
void get_M_2_SQRTPIq(FLOAT128_UNION_PTR dst) {dst->q = M_2_SQRTPIq;}
void get_M_SQRT2q(FLOAT128_UNION_PTR dst) {dst->q = M_SQRT2q;}
void get_M_SQRT1_2q(FLOAT128_UNION_PTR dst) {dst->q = M_SQRT1_2q;}


// math functions for float128:

/*
The following mathematical functions are available: 
acosq: arc cosine function
acoshq: inverse hyperbolic cosine function
asinq: arc sine function
asinhq: inverse hyperbolic sine function
atanq: arc tangent function
atanhq: inverse hyperbolic tangent function
atan2q: arc tangent function
cbrtq: cube root function
ceilq: ceiling value function
copysignq: copy sign of a number
coshq: hyperbolic cosine function
cosq: cosine function
erfq: error function
erfcq: complementary error function
expq: exponential function
expm1q: exponential minus 1 function
fabsq: absolute value function
fdimq: positive difference function
finiteq: check finiteness of value
floorq: floor value function
fmaq: fused multiply and add
fmaxq: determine maximum of two values
fminq: determine minimum of two values
fmodq: remainder value function
frexpq: extract mantissa and exponent
hypotq: Eucledian distance function
ilogbq: get exponent of the value
isinfq: check for infinity
isnanq: check for not a number
j0q: Bessel function of the first kind, first order
j1q: Bessel function of the first kind, second order
jnq: Bessel function of the first kind, n-th order
ldexpq: load exponent of the value
lgammaq: logarithmic gamma function
llrintq: round to nearest integer value
llroundq: round to nearest integer value away from zero
logbq: get exponent of the value
logq: natural logarithm function
log10q: base 10 logarithm function
log1pq: compute natural logarithm of the value plus one
log2q: base 2 logarithm function
lrintq: round to nearest integer value
lroundq: round to nearest integer value away from zero
modfq: decompose the floating-point number
nanq: return quiet NaN
nearbyintq: round to nearest integer
nextafterq: next representable floating-point number
powq: power function
remainderq: remainder function
remquoq: remainder and part of quotient
rintq: round-to-nearest integral value
roundq: round-to-nearest integral value, return __float128
scalblnq: compute exponent using FLT_RADIX
scalbnq: compute exponent using FLT_RADIX
signbitq: return sign bit
sincosq: calculate sine and cosine simultaneously
sinhq: hyperbolic sine function
sinq: sine function
sqrtq: square root function
tanq: tangent function
tanhq: hyperbolic tangent function
tgammaq: true gamma function
truncq: round to integer, towards zero
y0q: Bessel function of the second kind, first order
y1q: Bessel function of the second kind, second order
ynq: Bessel function of the second kind, n-th order
cabsq complex absolute value function
cargq: calculate the argument
cimagq imaginary part of complex number
crealq: real part of complex number
cacoshq: complex arc hyperbolic cosine function
cacosq: complex arc cosine function
casinhq: complex arc hyperbolic sine function
casinq: complex arc sine function
catanhq: complex arc hyperbolic tangent function
catanq: complex arc tangent function
ccosq complex cosine function:
ccoshq: complex hyperbolic cosine function
cexpq: complex exponential function
cexpiq: computes the exponential function of "i" times a
real value 
clogq: complex natural logarithm
clog10q: complex base 10 logarithm
conjq: complex conjugate function
cpowq: complex power function
cprojq: project into Riemann Sphere
csinq: complex sine function
csinhq: complex hyperbolic sine function
csqrtq: complex square root
ctanq: complex tangent function
ctanhq: complex hyperbolic tangent function
*/

// Now, I have to learn how to use it.

/* Prototypes for real functions */

#define myproc1(A,B,C) B->q = A(C->q);
#define cmyproc1(A,B,C) B->j = A(C->j);
#define cmyproc2(A,B,C) B->q = A(C->j);

//extern __float128 acosq (__float128) __quadmath_throw;
void myacosq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(acosq,dst,arg1)}
//extern __float128 acoshq (__float128) __quadmath_throw;
void myacoshq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(acoshq,dst,arg1)}
//extern __float128 asinq (__float128) __quadmath_throw;
void myasinq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(asinq,dst,arg1)}
//extern __float128 asinhq (__float128) __quadmath_throw;
void myasinhq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(asinhq,dst,arg1)}
//extern __float128 atanq (__float128) __quadmath_throw;
void myatanq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(atanq,dst,arg1)}
//extern __float128 atanhq (__float128) __quadmath_throw;
void myatanhq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(atanhq,dst,arg1)}

//extern __float128 atan2q (__float128, __float128) __quadmath_throw;
void myatan2q(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1, FLOAT128_UNION_PTR arg2)
{
	dst->q = atan2q(arg1->q, arg2->q);
}

//extern __float128 cbrtq (__float128) __quadmath_throw;
void mycbrtq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(cbrtq,dst,arg1)}
//extern __float128 ceilq (__float128) __quadmath_throw;
void myceilq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(ceilq,dst,arg1)}

//extern __float128 copysignq (__float128, __float128) __quadmath_throw;
void mycopysignq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1, FLOAT128_UNION_PTR arg2)
{
	dst->q = copysignq(arg1->q, arg2->q);
}

//extern __float128 coshq (__float128) __quadmath_throw;
void mycoshq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(coshq,dst,arg1)}
//extern __float128 cosq (__float128) __quadmath_throw;
void mycosq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(cosq,dst,arg1)}
//extern __float128 erfq (__float128) __quadmath_throw;
void myerfq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(erfq,dst,arg1)}
//extern __float128 erfcq (__float128) __quadmath_throw;
void myerfcq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(erfcq,dst,arg1)}
//extern __float128 expq (__float128) __quadmath_throw;
void myexpq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(expq,dst,arg1)}
//extern __float128 expm1q (__float128) __quadmath_throw;
void myexpm1q(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(expm1q,dst,arg1)}
//extern __float128 fabsq (__float128) __quadmath_throw;
void myfabsq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(fabsq,dst,arg1)}

//extern __float128 fdimq (__float128, __float128) __quadmath_throw;
void myfdimq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1, FLOAT128_UNION_PTR arg2)
{
	dst->q = fdimq(arg1->q, arg2->q);
}

//extern int finiteq (__float128) __quadmath_throw;
int myfiniteq(FLOAT128_UNION_PTR arg1)
{
	int ret;
	ret = finiteq(arg1->q);
	return ret;
}

//extern __float128 floorq (__float128) __quadmath_throw;
void myfloorq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(floorq,dst,arg1)}

//extern __float128 fmaq (__float128, __float128, __float128) __quadmath_throw;
void myfmaq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1, FLOAT128_UNION_PTR arg2, FLOAT128_UNION_PTR arg3)
{
	dst->q = fmaq(arg1->q, arg2->q, arg3->q);
}

//extern __float128 fmaxq (__float128, __float128) __quadmath_throw;
void myfmaxq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1, FLOAT128_UNION_PTR arg2)
{
	dst->q = fmaxq(arg1->q, arg2->q);
}
//extern __float128 fminq (__float128, __float128) __quadmath_throw;
void myfminq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1, FLOAT128_UNION_PTR arg2)
{
	dst->q = fminq(arg1->q, arg2->q);
}
//extern __float128 fmodq (__float128, __float128) __quadmath_throw;
void myfmodq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1, FLOAT128_UNION_PTR arg2)
{
	dst->q = fmodq(arg1->q, arg2->q);
}

//extern __float128 frexpq (__float128, int *) __quadmath_throw;
void myfrexpq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1, int * i2)
{
	dst->q = frexpq(arg1->q, i2);
}

//extern __float128 hypotq (__float128, __float128) __quadmath_throw;
void myhypotq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1, FLOAT128_UNION_PTR arg2)
{
	dst->q = hypotq(arg1->q, arg2->q);
}

//extern int isinfq (__float128) __quadmath_throw;
int myisinfq(FLOAT128_UNION_PTR arg1)
{
	int ret;
	ret = isinfq(arg1->q);
	return ret;
}
//extern int ilogbq (__float128) __quadmath_throw;
int myilogbq(FLOAT128_UNION_PTR arg1)
{
	int ret;
	ret = ilogbq(arg1->q);
	return ret;
}
//extern int isnanq (__float128) __quadmath_throw;
int myisnanq(FLOAT128_UNION_PTR arg1)
{
	int ret;
	ret = isnanq(arg1->q);
	return ret;
}

//extern __float128 j0q (__float128) __quadmath_throw;
void myj0q(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(j0q,dst,arg1)}
//extern __float128 j1q (__float128) __quadmath_throw;
void myj1q(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(j1q,dst,arg1)}

//extern __float128 jnq (int, __float128) __quadmath_throw;
void myjnq(FLOAT128_UNION_PTR dst, int i1, FLOAT128_UNION_PTR arg2)
{
	dst->q = jnq(i1, arg2->q);
}

//extern __float128 ldexpq (__float128, int) __quadmath_throw;
void myldexpq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1, int i2)
{
	dst->q = ldexpq(arg1->q, i2);
}

//extern __float128 lgammaq (__float128) __quadmath_throw;
void mylgammaq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(lgammaq,dst,arg1)}

//extern long long int llrintq (__float128) __quadmath_throw;
void myllrintq(long long int * out1, FLOAT128_UNION_PTR arg1)
{
	*out1 = llrintq(arg1->q); // *out should work, it copies it into storage address out1
}

//extern long long int llroundq (__float128) __quadmath_throw;
void myllroundq(long long int * out1, FLOAT128_UNION_PTR arg1)
{
	*out1 = llroundq(arg1->q); // *out should work, it copies it into storage address out1
}

//extern __float128 logq (__float128) __quadmath_throw;
void mylogq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(logq,dst,arg1)}
//extern __float128 log10q (__float128) __quadmath_throw;
void mylog10q(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(log10q,dst,arg1)}
//extern __float128 log2q (__float128) __quadmath_throw;
void mylog2q(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(log2q,dst,arg1)}
//extern __float128 log1pq (__float128) __quadmath_throw;
void mylog1pq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(log1pq,dst,arg1)}

//extern long int lrintq (__float128) __quadmath_throw;
long int mylrintq(FLOAT128_UNION_PTR arg1)
{
	long int ret;
	ret = lrintq(arg1->q);
	return ret;
}
//extern long int lroundq (__float128) __quadmath_throw;
long int mylroundq(FLOAT128_UNION_PTR arg1)
{
	long int ret;
	ret = lroundq(arg1->q);
	return ret;
}

//extern __float128 modfq (__float128, __float128 *) __quadmath_throw;
void mymodfq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1, FLOAT128_UNION_PTR arg2)
{
	dst->q = modfq(arg1->q, &arg2->q); // in2 is (__float128 *)
}

//extern __float128 nanq (const char *) __quadmath_throw;
void mynanq(FLOAT128_UNION_PTR dst, const char *str)
{
	dst->q = nanq(str);
}

//extern __float128 nearbyintq (__float128) __quadmath_throw;
void mynearbyintq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(nearbyintq,dst,arg1)}

//extern __float128 nextafterq (__float128, __float128) __quadmath_throw;
void mynextafterq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1, FLOAT128_UNION_PTR arg2)
{
	dst->q = nextafterq(arg1->q, arg2->q);
}

//extern __float128 powq (__float128, __float128) __quadmath_throw;
void mypowq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1, FLOAT128_UNION_PTR arg2)
{
	dst->q = powq(arg1->q, arg2->q);
}

//extern __float128 remainderq (__float128, __float128) __quadmath_throw;
void myremainderq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1, FLOAT128_UNION_PTR arg2)
{
	dst->q = remainderq(arg1->q, arg2->q);
}

//extern __float128 remquoq (__float128, __float128, int *) __quadmath_throw;
void myremquoq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1, FLOAT128_UNION_PTR arg2, int *iptr3)
{
	dst->q = remquoq(arg1->q, arg2->q, iptr3);
}

//extern __float128 rintq (__float128) __quadmath_throw;
void myrintq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(rintq,dst,arg1)}
//extern __float128 roundq (__float128) __quadmath_throw;
void myroundq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(roundq,dst,arg1)}

//extern __float128 scalblnq (__float128, long int) __quadmath_throw;
void myscalblnq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1, long int i2)
{
	dst->q = scalblnq(arg1->q, i2);
}

//extern __float128 scalbnq (__float128, int) __quadmath_throw;
void myscalbnq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1, int i2)
{
	dst->q = scalbnq(arg1->q, i2);
}

//extern int signbitq (__float128) __quadmath_throw;
int mysignbitq(FLOAT128_UNION_PTR arg1)
{
	int ret;
	ret = signbitq(arg1->q);
	return ret;
}

//extern void sincosq (__float128, __float128 *, __float128 *) __quadmath_throw;
void mysincosq(FLOAT128_UNION_PTR arg1, FLOAT128_UNION_PTR dst1, FLOAT128_UNION_PTR dst2)
{
	sincosq(arg1->q, &dst1->q, &dst2->q);
}

//extern __float128 sinhq (__float128) __quadmath_throw;
void mysinhq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(sinhq,dst,arg1)}
//extern __float128 sinq (__float128) __quadmath_throw;
void mysinq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(sinq,dst,arg1)}
//extern __float128 sqrtq (__float128) __quadmath_throw;
void mysqrtq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(sqrtq,dst,arg1)}
//extern __float128 tanq (__float128) __quadmath_throw;
void mytanq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(tanq,dst,arg1)}
//extern __float128 tanhq (__float128) __quadmath_throw;
void mytanhq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(tanhq,dst,arg1)}
//extern __float128 tgammaq (__float128) __quadmath_throw;
void mytgammaq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(tgammaq,dst,arg1)}
//extern __float128 truncq (__float128) __quadmath_throw;
void mytruncq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(truncq,dst,arg1)}
//extern __float128 y0q (__float128) __quadmath_throw;
void myy0q(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(y0q,dst,arg1)}
//extern __float128 y1q (__float128) __quadmath_throw;
void myy1q(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1) {myproc1(y1q,dst,arg1)}

//extern __float128 ynq (int, __float128) __quadmath_throw;
void myynq(FLOAT128_UNION_PTR dst, int i1, FLOAT128_UNION_PTR arg2)
{
	dst->q = ynq(i1, arg2->q);
}


// Addition, Subtraction, Multiplication, Division
void addq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1, FLOAT128_UNION_PTR arg2)
{
	dst->q = arg1->q + arg2->q;
}
void divideq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1, FLOAT128_UNION_PTR arg2)
{
	dst->q = arg1->q / arg2->q;
}
void multq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1, FLOAT128_UNION_PTR arg2)
{
	dst->q = arg1->q * arg2->q;
}
void subtractq(FLOAT128_UNION_PTR dst, FLOAT128_UNION_PTR arg1, FLOAT128_UNION_PTR arg2)
{
	dst->q = arg1->q - arg2->q;
}


// Complex numbers with __complex128
// See also:
// https://gcc.gnu.org/onlinedocs/gcc/Complex.html

// Some utility functions for quadmath's complex data type

// These return a __float128 in *dst, but take a __complex128 in *arg1

//extern __float128 cabsq (__complex128) __quadmath_throw;
void mycabsq(FLOAT128_UNION_PTR dst, COMPLEX128_UNION_PTR carg1) {cmyproc2(cabsq,dst,carg1)}
//extern __float128 cargq (__complex128) __quadmath_throw;
void mycargq(FLOAT128_UNION_PTR dst, COMPLEX128_UNION_PTR carg1) {cmyproc2(cargq,dst,carg1)}
//extern __float128 cimagq (__complex128) __quadmath_throw;
void mycimagq(FLOAT128_UNION_PTR dst, COMPLEX128_UNION_PTR carg1) {cmyproc2(cimagq,dst,carg1)}
//extern __float128 crealq (__complex128) __quadmath_throw;
void mycrealq(FLOAT128_UNION_PTR dst, COMPLEX128_UNION_PTR carg1) {cmyproc2(crealq,dst,carg1)}


// These *dst represent __complex128, which are two __float128's.

void get_Complex_I(COMPLEX128_UNION_PTR cdst)
{
	cdst->j = (0.0q + 1.0iq);
}

//extern __complex128 cacosq (__complex128) __quadmath_throw;
void mycacosq(COMPLEX128_UNION_PTR cdst, COMPLEX128_UNION_PTR carg1) {cmyproc1(cacosq,cdst,carg1)}
//extern __complex128 cacoshq (__complex128) __quadmath_throw;
void mycacoshq(COMPLEX128_UNION_PTR cdst, COMPLEX128_UNION_PTR carg1) {cmyproc1(cacoshq,cdst,carg1)}
//extern __complex128 casinq (__complex128) __quadmath_throw;
void mycasinq(COMPLEX128_UNION_PTR cdst, COMPLEX128_UNION_PTR carg1) {cmyproc1(casinq,cdst,carg1)}
//extern __complex128 casinhq (__complex128) __quadmath_throw;
void mycasinhq(COMPLEX128_UNION_PTR cdst, COMPLEX128_UNION_PTR carg1) {cmyproc1(casinhq,cdst,carg1)}
//extern __complex128 catanq (__complex128) __quadmath_throw;
void mycatanq(COMPLEX128_UNION_PTR cdst, COMPLEX128_UNION_PTR carg1) {cmyproc1(catanq,cdst,carg1)}
//extern __complex128 catanhq (__complex128) __quadmath_throw;
void mycatanhq(COMPLEX128_UNION_PTR cdst, COMPLEX128_UNION_PTR carg1) {cmyproc1(catanhq,cdst,carg1)}
//extern __complex128 ccosq (__complex128) __quadmath_throw;
void myccosq(COMPLEX128_UNION_PTR cdst, COMPLEX128_UNION_PTR carg1) {cmyproc1(ccosq,cdst,carg1)}
//extern __complex128 ccoshq (__complex128) __quadmath_throw;
void myccoshq(COMPLEX128_UNION_PTR cdst, COMPLEX128_UNION_PTR carg1) {cmyproc1(ccoshq,cdst,carg1)}
//extern __complex128 cexpq (__complex128) __quadmath_throw;
void mycexpq(COMPLEX128_UNION_PTR cdst, COMPLEX128_UNION_PTR carg1) {cmyproc1(cexpq,cdst,carg1)}
//extern __complex128 cexpiq (__float128) __quadmath_throw;
void mycexpiq(COMPLEX128_UNION_PTR cdst, COMPLEX128_UNION_PTR carg1) {cmyproc1(cexpiq,cdst,carg1)}
//extern __complex128 clogq (__complex128) __quadmath_throw;
void myclogq(COMPLEX128_UNION_PTR cdst, COMPLEX128_UNION_PTR carg1) {cmyproc1(clogq,cdst,carg1)}
//extern __complex128 clog10q (__complex128) __quadmath_throw;
void myclog10q(COMPLEX128_UNION_PTR cdst, COMPLEX128_UNION_PTR carg1) {cmyproc1(clog10q,cdst,carg1)}
//extern __complex128 conjq (__complex128) __quadmath_throw;
void myconjq(COMPLEX128_UNION_PTR cdst, COMPLEX128_UNION_PTR carg1) {cmyproc1(conjq,cdst,carg1)}

//extern __complex128 cpowq (__complex128, __complex128) __quadmath_throw;
void mycpowq(COMPLEX128_UNION_PTR cdst, COMPLEX128_UNION_PTR carg1, COMPLEX128_UNION_PTR carg2)
{
	cdst->j = cpowq(carg1->j, carg2->j);
}

//extern __complex128 cprojq (__complex128) __quadmath_throw;
void mycprojq(COMPLEX128_UNION_PTR cdst, COMPLEX128_UNION_PTR carg1) {cmyproc1(cprojq,cdst,carg1)}
//extern __complex128 csinq (__complex128) __quadmath_throw;
void mycsinq(COMPLEX128_UNION_PTR cdst, COMPLEX128_UNION_PTR carg1) {cmyproc1(csinq,cdst,carg1)}
//extern __complex128 csinhq (__complex128) __quadmath_throw;
void mycsinhq(COMPLEX128_UNION_PTR cdst, COMPLEX128_UNION_PTR carg1) {cmyproc1(csinhq,cdst,carg1)}
//extern __complex128 csqrtq (__complex128) __quadmath_throw;
void mycsqrtq(COMPLEX128_UNION_PTR cdst, COMPLEX128_UNION_PTR carg1) {cmyproc1(csqrtq,cdst,carg1)}
//extern __complex128 ctanq (__complex128) __quadmath_throw;
void myctanq(COMPLEX128_UNION_PTR cdst, COMPLEX128_UNION_PTR carg1) {cmyproc1(ctanq,cdst,carg1)}
//extern __complex128 ctanhq (__complex128) __quadmath_throw;
void myctanhq(COMPLEX128_UNION_PTR cdst, COMPLEX128_UNION_PTR carg1) {cmyproc1(ctanhq,cdst,carg1)}

// Corrected Code:
void caddq(COMPLEX128_UNION_PTR cdst, COMPLEX128_UNION_PTR carg1, COMPLEX128_UNION_PTR carg2)
{
	cdst->j = carg1->j + carg2->j;
}
void cdivideq(COMPLEX128_UNION_PTR cdst, COMPLEX128_UNION_PTR carg1, COMPLEX128_UNION_PTR carg2)
{
	cdst->j = carg1->j / carg2->j;
}
void cmultq(COMPLEX128_UNION_PTR cdst, COMPLEX128_UNION_PTR carg1, COMPLEX128_UNION_PTR carg2)
{
	cdst->j = carg1->j * carg2->j;
}
void csubtractq(COMPLEX128_UNION_PTR cdst, COMPLEX128_UNION_PTR carg1, COMPLEX128_UNION_PTR carg2)
{
	cdst->j = carg1->j - carg2->j;
}

/* Prototypes for complex functions */
/*
extern __float128 cabsq (__complex128) __quadmath_throw;
extern __float128 cargq (__complex128) __quadmath_throw;
extern __float128 cimagq (__complex128) __quadmath_throw;
extern __float128 crealq (__complex128) __quadmath_throw;
extern __complex128 cacosq (__complex128) __quadmath_throw;
extern __complex128 cacoshq (__complex128) __quadmath_throw;
extern __complex128 casinq (__complex128) __quadmath_throw;
extern __complex128 casinhq (__complex128) __quadmath_throw;
extern __complex128 catanq (__complex128) __quadmath_throw;
extern __complex128 catanhq (__complex128) __quadmath_throw;
extern __complex128 ccosq (__complex128) __quadmath_throw;
extern __complex128 ccoshq (__complex128) __quadmath_throw;
extern __complex128 cexpq (__complex128) __quadmath_throw;
extern __complex128 cexpiq (__float128) __quadmath_throw;
extern __complex128 clogq (__complex128) __quadmath_throw;
extern __complex128 clog10q (__complex128) __quadmath_throw;
extern __complex128 conjq (__complex128) __quadmath_throw;
extern __complex128 cpowq (__complex128, __complex128) __quadmath_throw;
extern __complex128 cprojq (__complex128) __quadmath_throw;
extern __complex128 csinq (__complex128) __quadmath_throw;
extern __complex128 csinhq (__complex128) __quadmath_throw;
extern __complex128 csqrtq (__complex128) __quadmath_throw;
extern __complex128 ctanq (__complex128) __quadmath_throw;
extern __complex128 ctanhq (__complex128) __quadmath_throw;
*/

// Compare functions:

int compareq(FLOAT128_UNION_PTR arg1, FLOAT128_UNION_PTR arg2)
{
	int results;
	results = (arg1->q > arg2->q) - (arg1->q < arg2->q);
	return results;
}

