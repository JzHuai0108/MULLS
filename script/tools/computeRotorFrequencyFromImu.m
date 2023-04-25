% computeRotorFrequencyFromImu
% kuangye lidar is rotating at 0.45 Hz

data = loadImuDataFromRosbag('/media/jhuai/BackupPlus/jhuai/data/kuangye-lidar/ceshidata_200s.bag');
% data = loadImuDataFromRosbag('/media/jhuai/BackupPlus/jhuai/data/kuangye-lidar/330ete_355s.bag');
% data = loadImuDataFromRosbag('/media/jhuai/BackupPlus/jhuai/data/kuangye-lidar/410ete_motor2s_307s.bag');

data(:, 1) = data(:, 1) - data(1, 1);
close all;
figure;
plot(data(:, 1), data(:, 2:4));
legend('x', 'y', 'z');
title('imu data');
xlabel('time (s)');
ylabel('acceleration (m/s^2)');

figure;
plot(data(:, 1), data(:, 5:7));
legend('x', 'y', 'z');
title('imu data');
xlabel('time (s)');
ylabel('angular velocity (rad/s)');

figure;
plot(data(:, 1), data(:, 8:10));
legend('x', 'y', 'z');
title('orientation');
xlabel('time (s)');
ylabel('q (rad/s)');


% fft to get the fundamental frequency
T = mean(diff(data(:, 1)));
fprintf('sampling period is %f sec\n', T);
Fs = 1/T;
L = size(data, 1);
f = Fs*(0:(L-1)/2)/L;

for i =7:9
    Y = fft(data(:, i));
    P2 = abs(Y/L);
    P1 = P2(1:(L+1)/2);
    P1(2:end) = 2*P1(2:end);
    figure
    plot(f,P1,"-o")
    title(["Single-Sided Spectrum of Original Signal ", num2str(i)])
    xlabel("f (Hz)")
    ylabel("|P1(f)|");
end
