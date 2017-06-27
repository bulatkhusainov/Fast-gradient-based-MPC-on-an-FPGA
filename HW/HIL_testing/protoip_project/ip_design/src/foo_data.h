/* 
* icl::protoip
* Author: asuardi <https://github.com/asuardi>
* Date: November - 2014
*/


#include <vector>
#include <iostream>
#include <stdio.h>
#include "math.h"
#include "ap_fixed.h"
#include <stdint.h>
#include <cstdlib>
#include <cstring>
#include <stdio.h>
#include <fstream>
#include <string>
#include <sstream>
#include <vector>
#include <hls_math.h>


// Define FLOAT_FIX_VECTOR_NAME=1 to enable  fixed-point (up to 32 bits word length) arithmetic precision or 
// FLOAT_FIX_VECTOR_NAME=0 to enable floating-point single arithmetic precision.
#define FLOAT_FIX_X_HAT_IN 1
#define FLOAT_FIX_U_OPT_OUT 1

//Input vectors INTEGERLENGTH:
#define X_HAT_IN_INTEGERLENGTH 5
//Output vectors INTEGERLENGTH:
#define U_OPT_OUT_INTEGERLENGTH 5


//Input vectors FRACTIONLENGTH:
#define X_HAT_IN_FRACTIONLENGTH 15
//Output vectors FRACTIONLENGTH:
#define U_OPT_OUT_FRACTIONLENGTH 15


//Input vectors size:
#define X_HAT_IN_LENGTH 20
//Output vectors size:
#define U_OPT_OUT_LENGTH 80




typedef uint32_t data_t_memory;


#if FLOAT_FIX_X_HAT_IN == 1
	typedef ap_fixed<X_HAT_IN_INTEGERLENGTH+X_HAT_IN_FRACTIONLENGTH,X_HAT_IN_INTEGERLENGTH,AP_TRN_ZERO,AP_SAT> data_t_x_hat_in;
	typedef ap_fixed<32,32-X_HAT_IN_FRACTIONLENGTH,AP_TRN_ZERO,AP_SAT> data_t_interface_x_hat_in;
#endif
#if FLOAT_FIX_X_HAT_IN == 0
	typedef float data_t_x_hat_in;
	typedef float data_t_interface_x_hat_in;
#endif
#if FLOAT_FIX_U_OPT_OUT == 1 
	typedef ap_fixed<U_OPT_OUT_INTEGERLENGTH+U_OPT_OUT_FRACTIONLENGTH,U_OPT_OUT_INTEGERLENGTH,AP_TRN_ZERO,AP_SAT> data_t_u_opt_out;
	typedef ap_fixed<32,32-U_OPT_OUT_FRACTIONLENGTH,AP_TRN_ZERO,AP_SAT> data_t_interface_u_opt_out;
#endif
#if FLOAT_FIX_U_OPT_OUT == 0 
	typedef float data_t_u_opt_out;
	typedef float data_t_interface_u_opt_out;
#endif
