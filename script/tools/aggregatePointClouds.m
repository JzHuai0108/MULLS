
% All point clouds are in the same world frame for the hovermap data in
% nebula data sequences.
fn = '/media/jhuai/BackupPlus/jhuai/data/nebula/L_Spot3_Mix/spot3_lidar_2021-09-21-13-34-15_7.bag';
topic = '/spot3/hvm/lidar/points';

fn = '/media/jhuai/BackupPlus/jhuai/data/nebula/R_Spot4_Mix/spot4_lidar_2021-09-22-13-05-03_0.bag';
topic = '/spot4/hvm/lidar/points';


datadir = '/media/jhuai/BackupPlus/jhuai/data/nebula/N_Husky2_Mix';
filestats = dir([datadir, '/*.bag']);
filenames = {filestats.name};
for i=1:numel(filenames)
    filenames{i} = fullfile(datadir, filenames{i});
    disp([num2str(i), ': ', filenames{i}]);
end

topic = '/husky2/hvm/lidar/points';

computeRelMotion = 0;
fn = filenames{6};
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

num = min(1000, length(pcmsgs));

for i =1:num
    c = uint8(rosReadField(pcmsgs{i}, 'intensity'));
    pc2 = pointCloud(rosReadXYZ(pcmsgs{i}), "Intensity", c);
    if computeRelMotion
        [T_1_2, pc2p] = pcregistericp(pc2, allpc, 'Metric','PointToPlane', 'Extrapolate', true, 'Verbose', false);
        pc2 = pc2p;
    end
    if i == 1
        allpc = pc2;
    else
        allpc = pointCloud([pc2.Location; allpc.Location],"Intensity", [c; allpc.Intensity]);
    end
end

figure(1)
hold on;
pcshow(allpc.Location, allpc.Intensity);
cap = 'Merged Raw Point Clouds';
title(cap);
xlabel("X(m)")
ylabel("Y(m)")
zlabel("Z(m)")


