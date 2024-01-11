%% Загрузка изображений
folderPath = 'Resources/';
files = dir(fullfile(folderPath, '*.png'));

% Подготовка массива для хранения изображений
numImages = numel(files);
imageArray = cell(1, numImages);

% Загрузка изображений в массив
for i = 1 : numImages
    imagePath = fullfile(folderPath, files(i).name);
    imageArray{i} = imread(imagePath);
end

%% Обработка изображений
xy_shifts = zeros(numImages - 1, 2); % Массив для хранения сдвигов
for i = 1 : (numImages-1) % Цикл для обработки всех пар изображений
    xy_shifts(i, :) = find_shift_xy(imageArray{i}, imageArray{i + 1});
end
disp(xy_shifts) % вывод сдвигов на экран


%% Функция вычисления относительных сдвигов для пары изображений
function shift = find_shift_xy(image1, image2)
shape  = size(image1);
% Преобразование Фурье изображений
f_image1 = fft2(image1);
f_image2 = fft2(image2);
% Вычисление Матрицы фазовой коррекции
phase_diff_matrix = f_image1 .* conj(f_image2);
phase_diff_matrix = phase_diff_matrix ./ abs(phase_diff_matrix());
% Вычисление матрицы корреляций
phase_cov_matrix = ifft2(phase_diff_matrix);
[max_row,max_col] =find(abs(phase_cov_matrix) == max(abs(phase_cov_matrix(:)))); % определение строки и столбца с максимальным элементом
center = [fix(shape(1) / 2), fix(shape(2) / 2)];
% Вычисление относительного сдвига
shift = [max_row, max_col];
shift(shift > center) = shift(shift > center) - shape(shift > center);
shift = fliplr(shift) - 1;
end