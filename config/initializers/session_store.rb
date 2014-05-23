# Be sure to restart your server when you modify this file.

Wtf::Application.config.session_store :redis_session_store, {
  key: '_sse_session',
  redis: {
    expire_after: 120.minutes,
    key_prefix: 'sse:session:'
  }
}
