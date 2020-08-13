
include myquadmath.e

--with trace
--trace(1)


atom ma
-- for later:  var = new_float128()
-- for later:  cvar = new_complex128()

ma = allocate_data(16)
mem_set(ma, 0, 16)
atom buf
buf = allocate_data(128)
mem_set(buf, 0, 128)

sequence st
object tmp


c_proc(get_M_PIq, {dst})

puts(1, "Test\n")
st = quadmath_snprintf(dst)
printf(1, "%s\n", {st})


puts(1, "Cos(pi) is\n")

mem_copy(ma, dst, 16)

c_proc(mycosq, {dst, ma})

st = quadmath_snprintf(dst)
printf(1, "%s\n\n", {st})


atom cma
cma = allocate_data(32)
mem_set(cma, 0, 32)


puts(1, "Complex i:\n\n")

c_proc(get_Complex_I, {cma})


c_proc(mycrealq, {ma, cma})
tmp = c_func(myquadmath_snprintf, {buf, 128, ma})
st = peek({buf, 128})
printf(1, "%s real\n", {st})
c_proc(mycimagq, {ma, cma})
tmp = c_func(myquadmath_snprintf, {buf, 128, ma})
st = peek({buf, 128})
printf(1, "%s imag\n", {st})
puts(1, "\n")

puts(1, "Complex i times Complex i, is negative one:\n\n")

c_proc(_cmultq, {cma, cma, cma})

c_proc(mycrealq, {ma, cma})
tmp = c_func(myquadmath_snprintf, {buf, 128, ma})
st = peek({buf, 128})
printf(1, "%s real\n", {st})
c_proc(mycimagq, {ma, cma})
tmp = c_func(myquadmath_snprintf, {buf, 128, ma})
st = peek({buf, 128})
printf(1, "%s imag\n", {st})
puts(1, "\n")



getc(0)
