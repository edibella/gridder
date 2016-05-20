function gridder_tests(tester)
  import Gridder.*
  % Test data comes from some gated cardiac perfusion data that has been PCA'd. It has already been put into a struct with expected cartesian size.
  load('test_gridder_data_4D.mat')

  % Test Griddata
  load('griddata_result.mat')
  KSpaceData = use_griddata(KSpaceData);
  tester.test(officialCartesianKSpace, KSpaceData.cartesianKSpace, ...
              'Griddata Test - kSpace');
  tester.test(officialKMask, KSpaceData.cartesianMask, ...
              'Griddata Test - kMask')

  % Reset between tests
  clear KSpaceData
  load('test_gridder_data_4D.mat')

  % Test GROG
  load('test_gx_gy_data.mat')
  load('grog_result.mat')
  KSpaceData = use_grog(KSpaceData, Gx, Gy);
  tester.test(officialCartesianKSpace, KSpaceData.cartesianKSpace, ...
              'GROG Test - kSpace')
  tester.test(officialKMask, KSpaceData.cartesianMask, ...
              'GROG Test - kMask')

  % Reset between tests
  clear KSpaceData
  load('test_gridder_data_4D.mat')

  % Test BINN
  load('binn_result.mat')
  KSpaceData = use_binn(KSpaceData);
  tester.test(officialCartesianKSpace, KSpaceData.cartesianKSpace, ...
              'BINN test - kSpace')
  tester.test(officialKMask, KSpaceData.cartesianMask, ...
              'BINN test - kMask')
end
