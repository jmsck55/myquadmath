
#include <stdlib.h>
#include <stdio.h>

#include "myquadmath.h"

int main()
{
    FLOAT128_UNION u;
    COMPLEX128_UNION c;
    char buf[128];
    
    //mystrtoflt128("123.123", &u);
    
    get_M_PIq(&u);

    myquadmath_snprintf(buf, sizeof buf, &u);
    printf("%s\n", buf);
    
    mycosq(&u, &u);
    //myfloorq(&u, &u);
    
    myquadmath_snprintf(buf, sizeof buf, &u);
    printf("%s\n\n", buf);
    

    get_Complex_I(&c);

    u.q = c.real;
    myquadmath_snprintf(buf, sizeof buf, &u); // print the real part
    printf("union: %s real\n", buf);

    u.q = c.imag;
    myquadmath_snprintf(buf, sizeof buf, &u); // print the imaginary part
    printf("union: %s imag\n\n", buf);


    mycrealq(&u, &c);
    myquadmath_snprintf(buf, sizeof buf, &u); // print the real part
    printf("%s real\n", buf);
    mycimagq(&u, &c);
    myquadmath_snprintf(buf, sizeof buf, &u); // print the imaginary part
    printf("%s imag\n\n", buf);
    
    cmultq(&c, &c, &c);

    printf("imagary numbers are the square root of negative one.\n");
    printf("sqrt(-1) * sqrt(-1) = 1\n");
    printf("0+1i times 0+1i equals -1 + 0i\n");
    mycrealq(&u, &c);
    myquadmath_snprintf(buf, sizeof buf, &u); // print the real part
    printf("%s real\n", buf);
    mycimagq(&u, &c);
    myquadmath_snprintf(buf, sizeof buf, &u); // print the imaginary part
    printf("%s imag\n\n", buf);

    getc(stdin);
    return 0;
}

