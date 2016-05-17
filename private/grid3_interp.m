function kSpaceOutput = grid3_interp(kSpaceInput, trajectory, nRows, nCols)
  % kSpaceInput - Non-cartesian k-space
  % trajectory - List of complex values corresponding to normalized k-space
  %              location. range is -0.5, 0.5
  % nRows, nCols - Output width and height
  warning 'off' % turn off griddata warnings

  [nReadouts, nRays] = size(kSpaceInput);

  kxMatrix = real(trajectory) * nRows;
  kyMatrix = imag(trajectory) * nCols;

  % Pre-allocate kSpaceOutput with an extra row and column.
  kSpaceOutput = zeros(nRows + 1, nCols + 1);

  % Find nearest integer coordinates
  nearestKx = round(kxMatrix);
  nearestKy = round(kyMatrix);

  cartesianData = griddata(kxMatrix, kyMatrix, kSpaceInput, nearestKx, nearestKy);

  % get rid of NaNs
  cartesianData(isnan(cartesianData)) = 0;

  % shift from kx coordinates (kx: -128 => 128)
  % to matrix indices (indices: 1 => 257)
  rowIndex = nearestKx + nRows/2 + 1;
  colIndex = nearestKy + nCols/2 + 1;

  for iReadout = 1:nReadouts
    for jRay = 1:nRays
      row = rowIndex(iReadout,jRay);
      col = colIndex(iReadout,jRay);
      kSpaceOutput(row,col) = cartesianData(iReadout,jRay);
    end
  end

  % Regridding results in +1 size increase
  % so drop first row and first col arbitrarily
  kSpaceOutput = kSpaceOutput(2:end,2:end);
end
