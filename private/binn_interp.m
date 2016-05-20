function kSpaceOutput = binn_interp(kSpaceInput, trajectory, nRows, nCols)
  % A function for regridding kSpace via a mixture of bilinear interpolation and
  %  nearest neighbor.

  % kSpace in should have dimensions [nReadouts, nRays]
  [nReadouts, nRays] = size(kSpaceInput);

  kxMatrix = real(trajectory) * nRows;
  kyMatrix = imag(trajectory) * nCols;

  % Pre-allocate kSpaceOutput with an extra row and column.
  kSpaceOutput = zeros(nRows + 1, nCols + 1);
  weightMatrix = zeros(nRows + 1, nCols + 1);

  for iReadout = 1:nReadouts
    for iRay = 1:nRays
      % Pull this point's kx, ky, and signal
      thisKx = kxMatrix(iReadout,iRay);
      thisKy = kyMatrix(iReadout,iRay);
      thisInputSignal = kSpaceInput(iReadout,iRay);

      % Find nearest integer coordinates
      nearestKx = round(thisKx);
      nearestKy = round(thisKy);

      % Calculate weight factor
      diffX = nearestKx - thisKx;
      diffY = nearestKy - thisKy;
      distance = sqrt(diffX^2 + diffY^2);
      weight = 1 - distance;

      % Find matrix indices corresponding to k-space coordinates
      rowIndex = nearestKx + nRows/2 + 1 ;
      colIndex = nearestKy + nCols/2 + 1;

      % Place weighted value into matrix
      kSpaceOutput(rowIndex,colIndex) = kSpaceOutput(rowIndex,colIndex) + thisInputSignal * weight;

      % Update weightMatrix
      weightMatrix(rowIndex,colIndex) = weightMatrix(rowIndex,colIndex) + weight;
    end
  end

  % Lastly, use point-wise division of kSpaceOutput by weightMatrix to average
  % the weighting factor
  nonZeroWeights = weightMatrix > 0;

  % Perform point-wise division
  kSpaceOutput(nonZeroWeights) = kSpaceOutput(nonZeroWeights) ./ weightMatrix(nonZeroWeights);

  % Regridding results in +1 size increase
  % so drop first row and first col arbitrarily
  kSpaceOutput = kSpaceOutput(2:end,2:end);
end
