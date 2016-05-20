function KSpaceData = use_griddata(KSpaceData)
  % Check KSpaceData struct
  requiredFields = { 'kSpace', 'trajectory', 'cartesianSize' };
  verify_struct(KSpaceData, requiredFields, 'KSpaceData');

  % Proceed
  function_handle = @grid3_interp;
  KSpaceData = interp_2d(KSpaceData, function_handle);
end
