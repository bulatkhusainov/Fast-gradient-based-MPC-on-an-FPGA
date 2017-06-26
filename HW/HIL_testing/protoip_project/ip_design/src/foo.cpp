/* 
* icl::protoip
* Author: asuardi <https://github.com/asuardi>
* Date: November - 2014
*/


#include "foo_data.h"


void foo_user(  data_t_x_hat_in x_hat_in_int[X_HAT_IN_LENGTH],
				data_t_u_opt_out u_opt_out_int[U_OPT_OUT_LENGTH]);


void foo	(
				uint32_t byte_x_hat_in_offset,
				uint32_t byte_u_opt_out_offset,
				volatile data_t_memory *memory_inout)
{

	#ifndef __SYNTHESIS__
	//Any system calls which manage memory allocation within the system, for example malloc(), alloc() and free(), must be removed from the design code prior to synthesis. 

	data_t_interface_x_hat_in *x_hat_in;
	x_hat_in = (data_t_interface_x_hat_in *)malloc(X_HAT_IN_LENGTH*sizeof(data_t_interface_x_hat_in));
	data_t_interface_u_opt_out *u_opt_out;
	u_opt_out = (data_t_interface_u_opt_out *)malloc(U_OPT_OUT_LENGTH*sizeof(data_t_interface_u_opt_out));

	data_t_x_hat_in *x_hat_in_int;
	x_hat_in_int = (data_t_x_hat_in *)malloc(X_HAT_IN_LENGTH*sizeof (data_t_x_hat_in));
	data_t_u_opt_out *u_opt_out_int;
	u_opt_out_int = (data_t_u_opt_out *)malloc(U_OPT_OUT_LENGTH*sizeof (data_t_u_opt_out));

	#else
	//for synthesis

	data_t_interface_x_hat_in  x_hat_in[X_HAT_IN_LENGTH];
	data_t_interface_u_opt_out  u_opt_out[U_OPT_OUT_LENGTH];

	static data_t_x_hat_in  x_hat_in_int[X_HAT_IN_LENGTH];
	data_t_u_opt_out  u_opt_out_int[U_OPT_OUT_LENGTH];

	#endif

	#if FLOAT_FIX_X_HAT_IN == 1
	///////////////////////////////////////
	//load input vectors from memory (DDR)

	if(!(byte_x_hat_in_offset & (1<<31)))
	{
		memcpy(x_hat_in,(const data_t_memory*)(memory_inout+byte_x_hat_in_offset/4),X_HAT_IN_LENGTH*sizeof(data_t_memory));

    	//Initialisation: cast to the precision used for the algorithm
		input_cast_loop_x_hat:for (int i=0; i< X_HAT_IN_LENGTH; i++)
			x_hat_in_int[i]=(data_t_x_hat_in)x_hat_in[i];

	}
	

	#elif FLOAT_FIX_X_HAT_IN == 0
	///////////////////////////////////////
	//load input vectors from memory (DDR)

	if(!(byte_x_hat_in_offset & (1<<31)))
	{
		memcpy(x_hat_in_int,(const data_t_memory*)(memory_inout+byte_x_hat_in_offset/4),X_HAT_IN_LENGTH*sizeof(data_t_memory));
	}

	#endif



	///////////////////////////////////////
	//USER algorithm function (foo_user.cpp) call
	//Input vectors are:
	//x_hat_in_int[X_HAT_IN_LENGTH] -> data type is data_t_x_hat_in
	//Output vectors are:
	//u_opt_out_int[U_OPT_OUT_LENGTH] -> data type is data_t_u_opt_out
	foo_user_top: foo_user(	x_hat_in_int,
							u_opt_out_int);


	#if FLOAT_FIX_U_OPT_OUT == 1
	///////////////////////////////////////
	//store output vectors to memory (DDR)

	if(!(byte_u_opt_out_offset & (1<<31)))
	{
		output_cast_loop_u_opt: for(int i = 0; i <  U_OPT_OUT_LENGTH; i++)
			u_opt_out[i]=(data_t_interface_u_opt_out)u_opt_out_int[i];

		//write results vector y_out to DDR
		memcpy((data_t_memory *)(memory_inout+byte_u_opt_out_offset/4),u_opt_out,U_OPT_OUT_LENGTH*sizeof(data_t_memory));

	}
	#elif FLOAT_FIX_U_OPT_OUT == 0
	///////////////////////////////////////
	//write results vector y_out to DDR
	if(!(byte_u_opt_out_offset & (1<<31)))
	{
		memcpy((data_t_memory *)(memory_inout+byte_u_opt_out_offset/4),u_opt_out_int,U_OPT_OUT_LENGTH*sizeof(data_t_memory));
	}

	#endif




}
