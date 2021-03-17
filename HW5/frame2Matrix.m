function [matrix,t,dt,height,width] = frame2Matrix(video)
    frames = video.NumFrames;
    height = video.Height;
    width = video.Width;
    matrix = zeros(height*width, frames);
    idx = 1;
    dt = 1/video.FrameRate;
    t = 0:dt:video.Duration;
    while hasFrame(video)
        currFrame = readFrame(video);
        frame2gray = rgb2gray(currFrame);
        matrix(:,idx) = reshape(frame2gray,height*width,1);
        idx = idx + 1;
    end
end

