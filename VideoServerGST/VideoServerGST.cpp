#include <VideoServerGST.h>


namespace DCLT
{

VideoServerGST::VideoServerGST(const int width, const int height, const std::string format, const std::string host, const int port)
{
  this->err = NULL;
  this->pipeline = NULL;
  this->appsrc = NULL;
  this->bytes_per_image_cache = -1;
  this->frame_index = 0;
  this->time_stamp = 0;
  this->then = std::chrono::system_clock::now();
  
  this->width = width;
  this->height = height;
  this->format = format;
  this->host = host;
  this->port = port;

  if(!gst_init_check(NULL, NULL, &err))
  {
    throw("VideoServerGST: gst_init_check:"+static_cast<std::string>(err->message));
  }

  this->pipeline = gst_pipeline_new(NULL);
  if(!this->pipeline)
  {
    throw("VideoServerGST: gst_pipeline_new: failed to create pipeline");
  }
  
  // create elements
  this->appsrc = this->element_make("appsrc");
  // GstElement* que = this->element_make("queue");
  // GstElement* vts = this->element_make("videotestsrc");
  GstElement* vcv = this->element_make("videoconvert");
  GstElement* enc = this->element_make("x264enc");
  GstElement* tsm = this->element_make("mpegtsmux");
  GstElement* rtp = this->element_make("rtpmp2tpay");
  // GstElement* pay = this->element_make("rtph264pay");
  GstElement* udp = this->element_make("udpsink");
  // GstElement* rtd = this->element_make("rtpmp2tdepay");
  // GstElement* tsd = this->element_make("tsdemux");
  // GstElement* par = this->element_make("h264parse");
  // GstElement* avd = this->element_make("avdec_h264");
  // GstElement* vc2 = this->element_make("videoconvert");
  // GstElement* xis = this->element_make("ximagesink");

  // configure elements
  GstCaps* caps = gst_caps_new_simple("video/x-raw",
    "format", G_TYPE_STRING, this->format.c_str(),
    "width", G_TYPE_INT, this->width,
    "height", G_TYPE_INT, this->height,
    "framerate", GST_TYPE_FRACTION, 0, 1, NULL);
  if(!caps)
  {
    throw("VideoServerGST: gst_caps_new_simple: failed to create create caps");
  }
  g_object_set(G_OBJECT(this->appsrc), "caps", caps, "format", GST_FORMAT_TIME, "stream-type", GST_APP_STREAM_TYPE_STREAM, NULL);
  // g_object_set(G_OBJECT(que), "max-size-buffers", 1, "leaky", 0, "silent", true, NULL);
  // g_object_set(G_OBJECT(pay), "config-interval", 1, NULL);
  // g_object_set(G_OBJECT(tsm), "alignment", 7, NULL);
  g_object_set(G_OBJECT(udp), "host", this->host.c_str(), "port", this->port, "sync", true, NULL);

  // add elements to pipeline and link
  gst_bin_add_many(GST_BIN(this->pipeline), this->appsrc, vcv, enc, tsm, rtp, udp, NULL);
  if(!gst_element_link_many(this->appsrc, vcv, enc, tsm, rtp, udp, NULL))
  {
    throw("VideoServerGST: gst_element_link_many: failed to link pipeline elements");
  }

  gst_element_set_state(this->pipeline, GST_STATE_PLAYING);
}
  
  
VideoServerGST::~VideoServerGST(void)
{
  if(this->pipeline)
  {
    gst_element_set_state(this->pipeline, GST_STATE_NULL);
    gst_object_unref(this->pipeline);
    this->pipeline = NULL;
  }
  if(this->err)
  {
    g_error_free(this->err);
    this->err = NULL;
  }
}
  
  
int VideoServerGST::bytes_per_image(void)
{
  if(this->bytes_per_image_cache<0)
  {
    this->bytes_per_image_cache = this->width*this->height;
    if(this->format=="Y444")
    {
      this->bytes_per_image_cache *= 3;
    }
    else if(this->format=="I420")
    {
      this->bytes_per_image_cache += this->bytes_per_image_cache/2; // integer truncation
    }
    else
    {
      throw("VideoServerGST: bytes_per_image: unrecognized image format");
    }
  }
  return this->bytes_per_image_cache;
}


void VideoServerGST::update_image(const std::vector<uint8_t>& image)
{
  GstMapInfo info;
  GstFlowReturn ret;
  GstBuffer* buffer;

  buffer = gst_buffer_new_allocate(NULL, this->bytes_per_image(), NULL);
  if(!buffer)
  {
    throw("VideoServerGST: gst_buffer_new_allocate: failed to allocate buffer");
  }

  // time transition
  std::chrono::time_point<std::chrono::system_clock> now = std::chrono::system_clock::now();
  if(this->frame_index == 0)
  {
    GST_BUFFER_DURATION(buffer) = 0;
  }
  else
  {
    GST_BUFFER_DURATION(buffer) = std::chrono::duration_cast<std::chrono::nanoseconds>(now-this->then).count();
  }
  this->then = now;
  time_stamp += GST_BUFFER_DURATION(buffer);
  GST_BUFFER_PTS(buffer) = time_stamp;
  this->frame_index++;

  // buffer mapping
  if(!gst_buffer_map(buffer, &info, GST_MAP_WRITE))
  {
    throw("VideoServerGST: gst_buffer_map: unable to map buffer");
  }
  std::memcpy(info.data, &image[0], this->bytes_per_image());
  gst_buffer_unmap(buffer, &info);

  // push buffer takes ownership so do not unref the buffer
  ret = gst_app_src_push_buffer(GST_APP_SRC(this->appsrc), buffer); 
  if(ret != GST_FLOW_OK)
  {
    throw("VideoServerGST: unable to push buffer");  
  }
}


GstElement* VideoServerGST::element_make(const std::string factoryname)
{
  GstElement* element;
  element = gst_element_factory_make(factoryname.c_str(), NULL);
  if(!element)
  {
    throw("VideoServerGST: gst_element_factory_make: failed to create "+factoryname);
  }
  return element;
}

} // namespace DCLT
