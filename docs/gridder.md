# Gridder


This package provides some pre-reconstruction interpolation methods for mapping data with a known non-Cartesian trajectory to nearby Cartesian points. This process is often called "gridding".

The four methods currently supported are

* **use_nufft** - This method uses the FftTools package to get a Cartesian image with NUFFT and then a simple fft2c to get back Cartesian k-space.

* **use_griddata** - This method just uses MATLAB's default `griddata` function internally.

* **use_grog** - This method accepts a Gx and Gy input in addition to the others and uses the GROG method to perform interpolation. There is more information about this method in the scGROG package.

* **use_binn** - This method uses bilinear interpolation of nearest neighbor points to perform interpolation.

### Inputs

All methods require a struct (internally called KSpaceData). This struct must have three fields

* kSpace       - The non-Cartesian k-space data to be interpolated

* trajectory   - A matrix of complex values ranging from -0.5 to 0.5.
                These values represent the k-space location of each
                point in the dataset.

                Note that the `trajectory` should ONLY contain unique
                k-space coordinates. For a multi-coil dataset this means the
                trajectory will not be the same size as the dataset! This
                property is used in GROG to determine whether the dataset is
                suitable for pre-interpolation with GROG.

                More info is given in the example below.

* cartesianSize - The dimensions of the interpolated cartesian dataset.
                  More detail given below.

Additionally the `use_nufft` and `use_grog` functions have extra inputs for their purposes. `use_nufft` expects a density compensation function while `use_grog` expects the `Gx` and `Gy` coefficient matrices.

### Output

The functions return the original struct with some new fields

* **cartesianKSpace** - The cartesian k-space created by interpolation. This k-space has max intensity at the center of the matrix, not the corners.

* **cartesianMask** - A logical (1 and 0) mask indicating location of interpolated points.

## Use

Let's say I want to reconstruct a golden-ratio data set that has 288
readout points, 24 rays, 32 coils, and 240 time-frames. My
matrix will have size 288 x 24 x 32 x 240.

For a golden-ratio acquisition, my trajectory need only have size
288 x 24 x 240 since all coils and z-slices will be identically
traced in k-space.

In order to use this package, I will first put coils at
the end of the matrix:

```matlab
KSpaceData.kSpace = permute(oldData, [1 2 4 3]);
```

`KSpaceData.kSpace` now has dimensions 288 x 24 x 240 x 32 and the first three
dimensions of my 5D dataset match the dimensions of my 3D trajectory.

---
**Important Note about GROG**

Because GROG is a multi-coil interpolator it needs to be able to find which
dimension of your matrix contains the coil information. At an attempt at
establishing convention over configuration, this code assumes the **last
dimension** of the matrix contains coils.

Furthermore, because GROG works best when given ALL 'rays', it assumes
all dimensions between the first and last dimensions contain ray information.

For example, if I have a dataset with dimensions 128x30x8 and a trajectory
with dimensions 128x30 then it is assumed that I have 8 coils and 30 rays.
If my dataset is 128x30x100x8 and my trajectory is 128x30x100 then the
GROG interpolator will reshape the data to form 3000 rays and 8 coils.
---

With these conventions establishing number of rays and coils, the only thing remaining is to decide what you want the final dimensions of the cartesian data to be. For this example I'll use:

```matlab
KSpaceData.cartesianSize = [288, 288, 240, 32];
```

Note that it is not necessary for the first two dimensions of the output
to be square or to correspond to another part of the original dataset.
It is however necessary that the remaining dimensions match.

With the above I can now use the griddata interpolator (for example) like so, assuming
I have a variable containing the trajectory:

```matlab
KSpaceData.trajectory = myTrajectory;
KSpaceData = Gridder.use_griddata(KSpaceData);
```
