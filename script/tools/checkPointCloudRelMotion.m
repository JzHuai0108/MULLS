
datadir = '/media/jhuai/BackupPlus/jhuai/data/kuangye-lidar/';
filestats = dir([datadir, '/*.bag']);
filenames = {filestats.name};
for i=1:numel(filenames)
    filenames{i} = fullfile(datadir, filenames{i});
    disp([num2str(i), ': ', filenames{i}]);
end

topic = '/velodyne_points';

computeRelMotion = 1;
fn = filenames{4};
bag = rosbag(fn);

% read point cloud message on topic
pcmsgs = readMessages(select(bag,'Topic', topic),'DataFormat','struct');
fprintf('number of velodyne message %d.\n', length(pcmsgs));

% get message time
a = uint64(pcmsgs{1}.Header.Stamp.Sec) * 1000000000 + uint64(pcmsgs{1}.Header.Stamp.Nsec);
b = uint64(pcmsgs{end}.Header.Stamp.Sec) * 1000000000 + uint64(pcmsgs{end}.Header.Stamp.Nsec);
duration = double(b - a) * 1e-9;
fprintf('velodyne message duration %.4f.\n', duration);

close all

d = 10;
indices = [d, d + 2];
ta = 0;
pclist = cell(2, 1);
for j = 1:2
    i = indices(j);
    c = uint8(rosReadField(pcmsgs{i}, 'intensity'));
    pc2 = pointCloud(rosReadXYZ(pcmsgs{i}), "Intensity", c);
    tb = double(pcmsgs{i}.Header.Stamp.Sec) + double(pcmsgs{i}.Header.Stamp.Nsec) * 1e-9;
    if computeRelMotion && j > 1
%         [T_1_2, pc2p] = pcregistericp(pc2, allpc, 'Metric','PointToPlane', 'Extrapolate', true, 'Verbose', false);
        dt = tb - ta;
        omega = 0.45 * 2 * pi;
        ct = cos(dt * omega);
        st = sin(dt * omega);
        R = [1, 0, 0; 0, ct, st; 0, -st, ct]
        pc2p = pointCloud(pc2.Location * R', "Intensity", pc2.Intensity);
    end
    pclist{j} = pc2;
    ta = tb;
end

figure(1)
pcshowpair(pclist{1}, pclist{2});
cap = 'Before rotation compensation';
title(cap);
xlabel("X(m)")
ylabel("Y(m)")
zlabel("Z(m)")


figure(2)
pcshowpair(pclist{1}, pc2p);
cap = 'After rotation compensation';
title(cap);
xlabel("X(m)")
ylabel("Y(m)")
zlabel("Z(m)")


