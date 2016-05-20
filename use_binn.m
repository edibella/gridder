function KSpaceData = use_binn(KSpaceData)
  % Check KSpaceData struct
  requiredFields = { 'kSpace', 'trajectory', 'cartesianSize' };
  verify_struct(KSpaceData, requiredFields, 'KSpaceData');

  % Proceed
  function_handle = @binn_interp;
  KSpaceData = interp_2d(KSpaceData, function_handle);
end
