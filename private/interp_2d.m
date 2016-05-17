function KSpaceData = interp_2d(KSpaceData, function_handle)
  % Take non-2D data, "flatten" to 3D then interp each 2D slice of the 3D set, and reshape back.
  [~, trajectoryRep] = repmat_match(KSpaceData.kSpace, KSpaceData.trajectory);

  % flatten to a 3D dataset since griddata needs to do 2D interpolations
  [nRows, nColumns, nFrames] = size(KSpaceData.kSpace);
  nCartRows = KSpaceData.cartesianSize(1);
  nCartColumns = KSpaceData.cartesianSize(2);
  nCartFrames = prod(KSpaceData.cartesianSize(3:end));
  cartesianSize3D = [nCartRows, nCartColumns, nCartFrames];

  if nFrames ~= nCartFrames
    error('The k-space provided and desired cartesian k-space can only vary in 1st and 2nd dimensions.')
  end

  % Reshape all the things
  kSpace3D = reshape(KSpaceData.kSpace, nRows, nColumns, nFrames);
  trajectory3D = reshape(trajectoryRep, nRows, nColumns, nFrames);
  KSpaceData.cartesianKSpace = zeros(cartesianSize3D);

  % Obtain cartesian k-space
  for z = 1:nCartFrames
    kSpaceSlice = kSpace3D(:,:,z);
    trajectorySlice = trajectory3D(:,:,z);
    KSpaceData.cartesianKSpace(:,:,z) = function_handle(kSpaceSlice, trajectorySlice, nCartRows, nCartColumns);
  end

  % Now reshape output
  KSpaceData.cartesianKSpace = reshape(KSpaceData.cartesianKSpace, KSpaceData.cartesianSize);

  % Create mask
  KSpaceData.cartesianMask = logical(abs(KSpaceData.cartesianKSpace));
end
