function [newMatrix1, newMatrix2] = repmat_match(matrix1, matrix2)
  % Input two matrices of different dimensionality and this function will give
  % them back with the smaller one `repmat`d into shape.
  % This assumes the dimensions they have in common already match.
  % If not, then you're using this incorrectly!

  % The following code is a little convoluted so I'll comment over
  % each line with example data to help clarify

  % Obtain size and dimensionality of each matrix
  sizeMatrix1 = size(matrix1); % => [288, 288]
  sizeMatrix2 = size(matrix2);  % => [288, 288, 5, 20]
  ndimsMatrix1 = length(sizeMatrix1); % => 2
  ndimsMatrix2 = length(sizeMatrix2); % => 4

  % Determine which one is larger
  if ndimsMatrix1 < ndimsMatrix2
    smallMatrix = matrix1;
    newMatrix2 = matrix2;
    smallSize = sizeMatrix1;
    largeSize = sizeMatrix2;
  elseif ndimsMatrix1 > ndimsMatrix2
    smallMatrix = matrix2;
    newMatrix1 = matrix1;
    smallSize = sizeMatrix2;
    largeSize = sizeMatrix1;
  else
    newMatrix1 = matrix1;
    newMatrix2 = matrix2;
    return
  end

  % Use the above information to repmat-match
  sizeDiff = length(largeSize) - length(smallSize); % => 2
  matchedSize = padarray(smallSize, [0, sizeDiff], 1, 'post'); % => [288, 288, 1, 1]
  matchedSize = matchedSize - 1; % => [287, 287, 0, 0]
  repeatCommand = largeSize - matchedSize; % => [1,1,5,20]

  % Now repmat out the smaller matrix
  matchedMatrix = repmat(smallMatrix, repeatCommand);

  % assign new matrices to rightful places
  if ndimsMatrix1 < ndimsMatrix2
    newMatrix1 = matchedMatrix;
  elseif ndimsMatrix1 > ndimsMatrix2
    newMatrix2 = matchedMatrix;
  end
end
