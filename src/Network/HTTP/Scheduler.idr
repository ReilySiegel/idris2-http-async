module Network.HTTP.Scheduler

import Network.HTTP.Message
import Network.HTTP.Error
import Network.HTTP.Protocol
import Utils.Streaming
import System.Concurrency

public export
record ScheduleResponse (m : Type -> Type) where
  constructor MkScheduleResponse
  raw_http_response : RawHttpResponse
  content : Channel (Either HttpError (List Bits8))

public export
record ScheduleRequest (e : Type) (m : Type -> Type) where
  constructor MkScheduleRequest
  raw_http_message : RawHttpMessage
  content : Stream (Of Bits8) m (Either e ())
  response : Channel (Either (Either HttpError e) (ScheduleResponse m))

public export
interface Scheduler (e : Type) (m : Type -> Type) (0 a : Type) where
  ||| Schedule a HTTP request
  schedule_request : a -> Protocol -> ScheduleRequest e m -> m ()
  ||| Evict all HTTP connections, returning scheduler to a clean state (and closing all resources)
  evict_all : a -> m ()

channel_to_stream : HasIO m => Channel (Either HttpError (List Bits8)) -> Stream (Of Bits8) m (Either (Either HttpError e) ())
channel_to_stream channel = do
  Right content <- liftIO $ channelGet channel
  | Left err => pure (Left (Left err))
  fromList_ content *> channel_to_stream channel

public export
request : {m, e : _} -> (HasIO m, Scheduler e m scheduler) =>
          scheduler -> Protocol -> RawHttpMessage -> Stream (Of Bits8) m (Either e ()) ->
          m (Either (Either HttpError e) (RawHttpResponse, Stream (Of Bits8) m (Either (Either HttpError e) ())))
request scheduler protocol msg content = do
  mvar <- makeChannel
  schedule_request scheduler protocol $ MkScheduleRequest msg content mvar 
  Right response <- channelGet mvar
  | Left err => pure $ Left err
  pure $ Right (response.raw_http_response, channel_to_stream response.content)