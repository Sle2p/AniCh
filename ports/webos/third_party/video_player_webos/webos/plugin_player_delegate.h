#ifndef PLUGIN_PLAYER_DELEGATE_H_
#define PLUGIN_PLAYER_DELEGATE_H_

class PluginPlayerDelegate {
public:
// Call at WebOSPlayer
  virtual void OnStateChanged(int state) = 0;
  virtual void OnInitialized() = 0;
  virtual void OnPlayCompleted() = 0;
  virtual void OnSeekCompleted() = 0;
  virtual void OnBufferingStart() = 0;
  virtual void OnBufferingEnd() = 0;
  virtual void OnBuffered(int64_t start, int64_t end) = 0;
  virtual void OnError(int64_t errCode,const std::string& errText) = 0;
};

#endif //PLUGIN_PLAYER_DELEGATE_H_
