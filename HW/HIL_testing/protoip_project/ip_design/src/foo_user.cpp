/* 
* icl::protoip
* Author: asuardi <https://github.com/asuardi>
* Date: November - 2014
*/


#include "foo_data.h"
#include "user_fgm_mpc.h"


void foo_user(  data_t_x_hat_in x_hat_in_int[X_HAT_IN_LENGTH],
				data_t_u_opt_out u_opt_out_int[U_OPT_OUT_LENGTH])
{
	fgm_mpc(x_hat_in_int, u_opt_out_int);
}
