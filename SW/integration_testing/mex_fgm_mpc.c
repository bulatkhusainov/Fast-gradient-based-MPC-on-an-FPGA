#include "mex.h"
#include "matrix.h"

#include "../src/user_fgm_mpc.h"

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{

	int i,j,k;
	double *u_opt_double; // output
	double *x_hat_double; // input
	
	// interface input matrices
	x_hat_double = mxGetPr(prhs[0]);
	
	// interface output matrices
	plhs[0] = mxCreateDoubleMatrix(n_opt_var,1,mxREAL);
	u_opt_double = mxGetPr(plhs[0]);

	// local input and output matrices
	d_fgm u_opt[n_opt_var];
	d_fgm x_hat[n_states];

	// input interface loops
	for(i = 0; i < n_states; i++)
		x_hat[i] = (d_fgm) x_hat_double[i];
		
	//call function
	fgm_mpc(x_hat, u_opt);
	
	//output interface loops
	for(i = 0; i < n_opt_var; i++)
		u_opt_double[i] = (double) u_opt[i];
    
}
