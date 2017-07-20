#ifndef USER_FGM_MPC 
#define USER_FGM_MPC 

#define n_iter    62
#define n_states  20
#define m_inputs  10
#define n_opt_var 50
//#define N         5

#include "user_protoip_definer.h"
#ifdef PROTOIP
	#include "foo_data.h"
	typedef data_t_x_hat_in d_fgm;
#else
	typedef float d_fgm;
#endif

void fgm_mpc(d_fgm x_hat[n_states], d_fgm u_opt[n_opt_var]);

#endif 
