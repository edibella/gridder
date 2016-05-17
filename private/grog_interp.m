function kSpaceOutput = grog_interp(kSpaceInput, Gx, Gy, trajectory, cartesianSize)
  % Moves radial k-space points onto a cartesian grid via the GROG method.
  % kSpaceInput - A 3D (nReadouts, nRays, nCoils) slice of k-space.
  % Gx, Gy      - the unit horizontal and vertical cartesian GRAPPA kernels
  nRows = cartesianSize(1);
  nCols = cartesianSize(2);

  [nReadouts, nRays, nCoils] = size(kSpaceInput);

  kxMatrix = real(trajectory) * nRows;
  kyMatrix = imag(trajectory) * nCols;

  % Pre-allocate kSpaceOutput with an extra row and column.
  kSpaceOutput = zeros(nRows + 1, nCols + 1, nCoils);
  countMatrix = zeros(nRows + 1, nCols + 1);

  % Find nearest integer coordinates
  nearestKxMatrix = round(kxMatrix);
  nearestKyMatrix = round(kyMatrix);

  for iReadout = 1:nReadouts
    for iRay = 1:nRays
      % Pull this point's kx, ky, and multi-coil signal
      thisKx = kxMatrix(iReadout,iRay);
      thisKy = kyMatrix(iReadout,iRay);
      thisInputSignal = squeeze(kSpaceInput(iReadout, iRay, :));

      % Find nearest integer coordinates
      nearestKx = round(thisKx);
      nearestKy = round(thisKy);

      % calculate distance
      diffX = nearestKx - thisKx;
      diffY = nearestKy - thisKy;

      % Find matrix indices corresponding to k-space coordinates
      rowIndex = nearestKx + nRows/2 + 1;
      colIndex = nearestKy + nCols/2 + 1;

      % Shift cartesian point
      shiftedPoint = Gx^diffX * Gy^diffY * thisInputSignal; % Nc x 1
      shiftedPoint = reshape(shiftedPoint, [1 1 nCoils]);

      % Load result into output matric and bump the counter
      kSpaceOutput(rowIndex, colIndex, :) = kSpaceOutput(rowIndex, colIndex, :) + shiftedPoint;
      countMatrix(rowIndex, colIndex, :) = countMatrix(rowIndex, colIndex, :) + 1;
    end
  end

  % Lastly, use point-wise division of kSpaceOutput by weightMatrix to average
  nonZeroCount = countMatrix > 0;

  for iCoil = 1:nCoils
    % Extract one coil
    coilSignal = kSpaceOutput(:,:,iCoil);
    % Perform point-wise division
    coilSignal(nonZeroCount) = coilSignal(nonZeroCount) ./ countMatrix(nonZeroCount);
    % Store in output
    kSpaceOutput(:,:,iCoil) = coilSignal;
  end

  % Regridding results in +1 size increase
  % so drop first row and first col arbitrarily
  kSpaceOutput = kSpaceOutput(2:end,2:end,:);
end
