function KSpaceData = use_nufft(KSpaceData, densityCompensation)
  % Check KSpaceData struct
  requiredFields = { 'kSpace', 'trajectory', 'cartesianSize' };
  verify_struct(KSpaceData, requiredFields, 'KSpaceData');

  % Get imSize
  imSize = [KSpaceData.cartesianSize(1), KSpaceData.cartesianSize(2)];

  % Create NUFFT object
  nufftObj = FftTools.MultiNufft(KSpaceData.trajectory, densityCompensation, [0,0], imSize);

  % Create cartesian image and kspace
  cartesianImage = nufftObj' * KSpaceData.kSpace;
  KSpaceData.cartesianKSpace = FftTools.fft2c(cartesianImage);

  % And a rudimentary method for creating a mask, there may be a better way.
  KSpaceData.cartesianMask = logical(abs(KSpaceData.cartesianKSpace));
end
