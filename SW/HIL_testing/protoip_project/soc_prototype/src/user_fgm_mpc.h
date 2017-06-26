#define n_iter    424
#define n_states  20
#define m_inputs  10
#define n_opt_var 50
#define N         5

typedef float d_fgm;

void fgm_mpc(d_fgm x_hat[n_states], d_fgm u_opt[n_opt_var]);

