function imuData = loadImuDataFromRosbag(bagname, imutopic)
    bag = rosbag(bagname);
    imu = select(bag,'Topic','/imu/data');
    imuMsgs = readMessages(imu);
    imuData = zeros(length(imuMsgs),11);
    for i = 1:length(imuMsgs)
        t = imuMsgs{i}.Header.Stamp.Sec + imuMsgs{i}.Header.Stamp.Nsec * 1e-9;
        imuData(i, :) = [t, imuMsgs{i}.LinearAcceleration.X, imuMsgs{i}.LinearAcceleration.Y, imuMsgs{i}.LinearAcceleration.Z, ...
            imuMsgs{i}.AngularVelocity.X, imuMsgs{i}.AngularVelocity.Y, imuMsgs{i}.AngularVelocity.Z, imuMsgs{i}.Orientation.X, ...
            imuMsgs{i}.Orientation.Y, imuMsgs{i}.Orientation.Z, imuMsgs{i}.Orientation.W];
    end
    [rootdir, basename, ext] = fileparts(bagname);
    fn = fullfile(rootdir, [basename, '-imu.mat']);
    fprintf('save imu data to %s\n', fn);
    save(fn, 'imuData');
end
