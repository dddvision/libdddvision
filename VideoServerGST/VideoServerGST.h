#ifndef DCLTVIDEOSERVERGST_H
#define DCLTVIDEOSERVERGST_H

#include <chrono>
#include <cstdint>
#include <cstring>
#include <gst/gst.h>
#include <gst/app/gstappsrc.h>
#include <string>
#include <vector>


namespace DCLT
{

class VideoServerGST
{
private: 
  GError* err;
  GstElement* pipeline;
  GstElement* appsrc;
  
  int bytes_per_image_cache;
  int frame_index;
  GstClockTime time_stamp;
  std::chrono::time_point<std::chrono::system_clock> then;

  int width;
  int height;
  std::string format;
  std::string host;
  int port;

  GstElement* element_make(const std::string factoryname);

public:
  VideoServerGST(const int width, const int height, const std::string format, const std::string host, const int port);  
  ~VideoServerGST(void);
  int bytes_per_image(void);
  void update_image(const std::vector<uint8_t>& image);
};

} // namespace DCLT

#endif
