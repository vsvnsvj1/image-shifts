
%% Загрузка изображений
folderPath = 'Resources/';
files = dir(fullfile(folderPath,'*.png'));

% Подготовка массива для хранения изображений
numImages = numel(files);
imageArray = cell(1, numImages);

% Загрузка изображений в массив
for i = 1:numImages
    imagePath = fullfile(folderPath, files(i).name);
    imageArray{i} = imread(imagePath);
end

%% Цикл, в котором вычисляются сдвиги для пар изображений в массиве
xy_shifts = zeros(9,2);
for i = 1:(numImages-1)
    xy_shifts(i,:) = (find_shift_xy(imageArray{i},imageArray{i + 1}));
end
xy_shifts
%% Итоговое сравнение первого(сдвинутого) и последнего изображения
imshowpair(imageArray{numImages},imtranslate(imageArray{1},sum(xy_shifts)),...
    'falsecolor')
%% Функция, вычисляющая сдвиг для пары изображений
function shift = find_shift_xy(img1,img2)
% Рассматриваемая пара изображений

[rows,cols] = size(img1);
% Преобразование фурье изображений
f_img1 = fft2(img1);
f_img2 = fft2(img2);
% Вычисление корреляционной матрицы
corr = ifft2(f_img2.*conj(f_img1));
% Поиск максимального корреляционного коэфицента
[max_correlation, idx] = max(corr(:));
% Вычисление  относительного сдвига изображений
[xpeak, ypeak] = ind2sub(size(corr), idx);
yoffSet = xpeak - rows ;
xoffSet = ypeak  ;
shift = [xoffSet,yoffSet];
%% Вывод результатов вычисления сдвига
imshowpair(img2,imtranslate(img1,shift),'falsecolor');
end