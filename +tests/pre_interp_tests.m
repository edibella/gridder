function pre_interp_tests(tester)
  import Gridder.*
  % Test data comes from some gated cardiac perfusion data that has been PCA'd. It has already been put into a struct with expected cartesian size.
  load('test_pre_interp_data_4D.mat')

  % Test Griddata
  load('griddata_result.mat')
  KSpaceData = use_griddata(KSpaceData);
  tester.test(officialCartesianKSpace, KSpaceData.cartesianKSpace, ...
              'Griddata Test - kSpace');
  tester.test(officialKMask, KSpaceData.cartesianMask, ...
              'Griddata Test - kMask')

  % Reset between tests
  clear KSpaceData
  load('test_pre_interp_data_4D.mat')

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
  load('test_pre_interp_data_4D.mat')

  % Test Nearest Neighbor
  load('nn_result.mat')
  KSpaceData = use_nearest_neighbor(KSpaceData);
  tester.test(officialCartesianKSpace, KSpaceData.cartesianKSpace, ...
              'NN test - kSpace')
  tester.test(officialKMask, KSpaceData.cartesianMask, ...
              'NN test - kMask')
end
