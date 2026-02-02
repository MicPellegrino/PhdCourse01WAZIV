import numpy as np 
from skimage.measure import find_contours
import circle_fit as cf

# TODO: Add comments!

def circle_fit_droplet(intf_contour, z_sub) :
    M = len(intf_contour[0,:])
    data_circle_x = []
    data_circle_z = []
    for k in range(M) :
        if intf_contour[1,k] > z_sub :
            data_circle_x.append(intf_contour[0,k])
            data_circle_z.append(intf_contour[1,k])
    data_circle_x = np.array(data_circle_x)
    data_circle_z = np.array(data_circle_z)
    return cf.least_squares_circle(np.stack((data_circle_x, data_circle_z), axis=1))

def detect_contour (density_array, density_target, hx, hz) :
    contour = find_contours(density_array, density_target, fully_connected='high')
    if len(contour)>1 :
        contour = sorted(contour, key=lambda x : len(x))
    h = np.array([[hx, 0.0],[0.0, hz]])
    contour = np.matmul(h,(contour[-1].transpose()))
    contour = contour + np.array([[0.5*hx],[0.5*hz]])
    return contour

def read_density(dat_file_name) :
    density = np.loadtxt(dat_file_name)
    return density

def contact_angle(density, Lx, Lz, dens_thresh, z_sub) :
    Nx = density.shape[0]
    Nz = density.shape[1]
    hx = Lx/Nx
    hz = Lz/Nz
    x = np.linspace(0,Lx,Nx)
    z = np.linspace(0,Lz,Nz)
    X, Z = np.meshgrid(x, z, indexing='ij')
    intf_contour = detect_contour(density, dens_thresh, hx, hz)
    xc, zc, R, residue = circle_fit_droplet(intf_contour, z_sub)
    radius_circle = 2*np.sqrt(R*R-(z_sub-zc)**2)
    cot_circle = (z_sub-zc)/np.sqrt(R*R-(z_sub-zc)**2)
    theta_circle = np.rad2deg( -np.arctan( cot_circle )+0.5*np.pi )
    theta_circle = theta_circle + 180*(theta_circle<=0)
    print("Equilibrium contact angle:",theta_circle,"deg")
    # TODO: The output should go into a struct. Or possibly wrap everything in a class.
    return xc, zc, R, x, z, X, Z, intf_contour

if __name__ == "__main__" :

    Lx = 16.18400
    Lz = 12.00000
    z_sub = 2.6
    dens_thresh = 40
    dat_file_name = "flat/nvt-1kJmol/densmap.dat"

    density = read_density(dat_file_name)
    xc, zc, R, x, z, X, Z, intf_contour = contact_angle(density, Lx, Lz, dens_thresh, z_sub)

    s = np.linspace(0,2*np.pi,250)
    circle_x = xc + R*np.cos(s)
    circle_z = zc + R*np.sin(s)

    import matplotlib.pyplot as plt
    cmap = plt.colormaps['Blues']
    fig = plt.figure()
    pmesh = plt.pcolormesh(X, Z, density, cmap=cmap)
    pcont = plt.plot(intf_contour[0,:], intf_contour[1,:], 'k-')
    pwall = plt.plot(x, z_sub*np.ones_like(x), 'r-')
    pcirc = plt.plot(circle_x, circle_z, 'r-')
    fig.colorbar(pmesh)
    plt.axis('scaled')
    plt.xlim([0,Lx])
    plt.ylim([0,Lz])
    plt.show()