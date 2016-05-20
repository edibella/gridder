function KSpaceData = use_grog(KSpaceData, Gx, Gy)
  % Check KSpaceData struct
  requiredFields = { 'kSpace', 'trajectory', 'cartesianSize' };
  verify_struct(KSpaceData, requiredFields, 'KSpaceData');

  % Permute time to end of 4D data for convenience
  if ndims(KSpaceData.kSpace) == 4
    KSpaceData.kSpace = permute(KSpaceData.kSpace, [1 2 4 3]);
    KSpaceData.cartesianSize(3:4) = fliplr(KSpaceData.cartesianSize(3:4));
  end

  % Interpolate frame-by-frame
  KSpaceData.cartesianKSpace = zeros(KSpaceData.cartesianSize);
  for iTime = 1:size(KSpaceData.kSpace, 4);
    timeFrame = KSpaceData.kSpace(:,:,:,iTime);
    trajectoryFrame = KSpaceData.trajectory(:,:,iTime);
    cartesianSlice = grog_interp(timeFrame, Gx, Gy, trajectoryFrame, KSpaceData.cartesianSize);
    KSpaceData.cartesianKSpace(:,:,:,iTime) = cartesianSlice;
  end

  % permute back if needed
  if ndims(KSpaceData.kSpace) == 4
    KSpaceData.cartesianKSpace = permute(KSpaceData.cartesianKSpace, [1 2 4 3]);
    KSpaceData.cartesianSize(3:4) = fliplr(KSpaceData.cartesianSize(3:4));
  end

  % Create mask
  KSpaceData.cartesianMask = logical(abs(KSpaceData.cartesianKSpace));
end
