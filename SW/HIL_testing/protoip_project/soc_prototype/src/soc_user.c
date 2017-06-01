/* 
* icl::protoip
* Authors: asuardi <https://github.com/asuardi>, bulatkhusainov <https://github.com/bulatkhusainov>
* Date: November - 2014
*/


#include "soc_user.h"
#include "foo_function_wrapped.h"
#include "user_fgm_mpc.h"


void soc_user(float soc_x_hat_in[SOC_X_HAT_IN_VECTOR_LENGTH],float soc_u_opt_out[SOC_U_OPT_OUT_VECTOR_LENGTH])
{
	// call fast gradient controller
	fgm_mpc( soc_x_hat_in, soc_u_opt_out);
}


/*
	// declare input and output interfaces arrays
	float *x_in_in;
	float *y_out_out;


	// send data to DDR
	send_x_in_in(x_in_in);


	// call hardware accelerator assuming all interfaces are involoved
	start_foo(1,1);


	// wait for IP to finish
	while(!(finished_foo())){;}


	// read data from DDR
	receive_y_out_out(y_out_out);
*/