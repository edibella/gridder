function KSpaceData = use_nearest_neighbor(KSpaceData)
  % Check KSpaceData struct
  requiredFields = { 'kSpace', 'trajectory', 'cartesianSize' };
  PackageManagement.verify_struct(KSpaceData, requiredFields, 'KSpaceData');
  
  % Proceed
  function_handle = @nn_interp;
  KSpaceData = interp_2d(KSpaceData, function_handle);
end
