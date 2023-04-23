% From this test, we found that for nebula dataset, the hovermap ST rotates
% at about 1 Hz, 1.03 Hz exactly.
data = readmatrix('/media/jhuai/T7/jhuai/nebulaN/husky2_lidar_2021-09-21-13-15-26_3_hovermap/result/pose_l_lo_xxx_id.txt');
data = readmatrix('/media/jhuai/T7/jhuai/nebulaN/husky2_lidar_2021-09-21-13-13-49_0_hovermap/result/pose_l_lo_xxx_id.txt');
data = readmatrix('/media/jhuai/BackupPlus/jhuai/data/nebula/L_Spot3_Mix/spot3_lidar_2021-09-21-13-13-27_0_hovermap/result/pose_l_lo_xxx_id.txt');

size(data)

qs = zeros(size(data, 1), 4);

for i = 1:size(data, 1)
    d = data(i, :);
    T = reshape(d, 4, 3)';
    R = T(1:3, 1:3);
    q = rotm2quat(R);
    qs(i, :) = q;
end

% fft to get the fundamental frequency
Fs = 20;
T = 1/Fs;
L = size(qs, 1);
f = Fs*(0:(L-1)/2)/L;
close all;

for i =1:3
    Y = fft(qs(:, i));
    P2 = abs(Y/L);
    P1 = P2(1:(L+1)/2);
    P1(2:end) = 2*P1(2:end);
    figure
    plot(f,P1,"-o")
    title(["Single-Sided Spectrum of Original Signal ", num2str(i)])
    xlabel("f (Hz)")
    ylabel("|P1(f)|");
end

% figure;
% plot(qs(:, 1));
% plot(qs(:, 2));
% plot(qs(:, 3));
% legend('x', 'y', 'z');
%