// DEPENDENCIES:
// sudo apt install ssh xauth xorg ubuntu-drivers-common ubuntu-restricted-extras libva-dev gstreamer*1.0* libgstreamer*1.0*
// sudo apt-get remove gstreamer*vaapi*
// sudo apt install --reinstall libgl1-mesa-glx
// sudo apt install mesa-utils nvidia-persistenced
//
// COMPILE
// cmake .
// make
//
// TEST:
// export DISPLAY=localhost:0
// gst-launch-1.0 udpsrc port=5000 caps=application/x-rtp ! rtpmp2tdepay ! tsdemux ! h264parse ! avdec_h264 ! videoconvert ! ximagesink sync=false
// (new terminal)
// ./testVideoServerGST
//
// HIGH QUALITY STANDALONE:
// gst-launch-1.0 videotestsrc ! videoconvert ! ximagesink
// gst-launch-1.0 videotestsrc ! videoconvert ! x264enc ! h264parse ! avdec_h264 ! videoconvert ! ximagesink
// gst-launch-1.0 videotestsrc ! videoconvert ! x264enc ! rtph264pay ! rtph264depay ! h264parse ! avdec_h264 ! videoconvert ! ximagesink
// gst-launch-1.0 videotestsrc ! videoconvert ! x264enc ! mpegtsmux ! rtpmp2tpay ! rtpmp2tdepay ! tsdemux ! h264parse ! avdec_h264 ! videoconvert ! ximagesink
//
// HIGH QUALITY H264 SERVER/CLIENT:
// gst-launch-1.0 videotestsrc ! videoconvert ! x264enc ! rtph264pay config-interval=1 ! udpsink host=127.0.0.1 port=5000 sync=true
// gst-launch-1.0 udpsrc port=5000 caps=application/x-rtp ! rtph264depay ! h264parse ! avdec_h264 ! videoconvert ! ximagesink sync=false
//
// HIGH QUALITY H264/MPEG SERVER/CLIENT:
// gst-launch-1.0 videotestsrc ! videoconvert ! x264enc ! mpegtsmux ! rtpmp2tpay ! udpsink host=127.0.0.1 port=5000 sync=true
// gst-launch-1.0 udpsrc port=5000 caps=application/x-rtp ! rtpmp2tdepay ! tsdemux ! h264parse ! avdec_h264 ! videoconvert ! ximagesink sync=false
//
// REFERENCES:
// https://gstreamer.freedesktop.org/documentation/application-development/basics/helloworld.html
// https://gstreamer.freedesktop.org/documentation/frequently-asked-questions/using.html
// https://gist.github.com/nebgnahz/26a60cd28f671a8b7f522e80e75a9aa5
//
// DEBUG:
// Prepend executable with GST_DEBUG=4


#include <VideoServerGST.h>

#include <cstdio>
#include <cstdint>
#include <string>
#include <vector>
#include <unistd.h>


class RandBitShift
{
private:
  uint64_t x = 0;
  uint64_t w = 0;
  uint64_t s = 0xb5ad4eceda1ce2a9;

public:
  RandBitShift(uint64_t x0 = 0)
  {
    this->x = x0;
  }

  void randi(uint32_t* y)
  {
    this->x *= this->x;
    this->w += this->s;
    this->x += this->w;
    (*y) = (this->x>>32) | (this->x<<32);
  }
  
  void randi(std::vector<uint8_t>& img)
  {
    for(int p = 0; p<img.size(); p += 4)
    {
      randi(reinterpret_cast<uint32_t*>(&img[p]));
    }
  }
};


void safeMain(void)
{
  int width = 1024;
  int height = 768;
  std::string format("Y444"); // ALTERNATIVE: I420
  std::string host("127.0.0.1"); // NOTE: http:// prefix may not work
  int port = 5000;
  double frameRate = 30.0;
  std::vector<uint8_t> data;
  DCLT::VideoServerGST vs(width, height, format, host, port);
  RandBitShift rbs;
  data.resize(vs.bytes_per_image());
  for(int k = 0; k<10000; ++k)
  {
    usleep(1000000.0/frameRate);
    rbs.randi(data);
    printf("update_image:%d\n", k);
    vs.update_image(data);
  }
}


int main(void)
{
try
  {
    safeMain();
  }
  catch(std::exception& err)
  {
    fprintf(stderr, "ERROR: %s\n", err.what());
  }
  catch(std::string& err)
  {
    fprintf(stderr, "ERROR: %s\n", err.c_str());
  }
  catch(const char* err)
  {
    fprintf(stderr, "ERROR: %s\n", err);
  }
  catch(...)
  {
    fprintf(stderr, "ERROR: unhandled exception\n");
  }
}

