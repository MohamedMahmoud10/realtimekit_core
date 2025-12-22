
import com.cloudflare.realtimekit.RtkSink
import io.flutter.plugin.common.EventChannel.EventSink

class RtkSinkWrapper(private val sink: EventSink): RtkSink {
    override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
        sink.error(errorCode, errorMessage, errorDetails)
    }

    override fun success(result: Any?) {
        sink.success(result)
    }
}