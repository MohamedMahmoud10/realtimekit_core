package com.cloudflare.realtimekit.flutter

import android.app.DownloadManager
import android.content.Context
import android.net.Uri
import android.os.Environment
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

internal class ChatFileDownloader {

  companion object {
    private const val DATE_FORMAT_FALLBACK_FILE_NAME: String = "yyyy-MM-dd_HH-mm-ss"
    private const val PREFIX_FALLBACK_FILE_NAME: String = "chat_file_"

    private fun getSanitizedFileNameOrNull(fileName: String) : String? {
      if(fileName.isBlank()) return null
      return fileName.substringAfterLast('/')
    }

    private fun parseFilenameFromUrl(url: String) : String? {
      return url.substringAfterLast('/')
        .takeIf { it.isNotBlank() }
        ?.substringBefore('?')
    }


    private fun createFallbackFileName() : String {
      val dateString = SimpleDateFormat(DATE_FORMAT_FALLBACK_FILE_NAME, Locale.getDefault())
        .format(Date())
        .toString()

      return "${PREFIX_FALLBACK_FILE_NAME}${dateString}"
    }

    fun enqueue(context: Context, url: String, fileName: String = ""){
      val downloadManager = context.getSystemService(Context.DOWNLOAD_SERVICE) as DownloadManager

      val name = getSanitizedFileNameOrNull(fileName) ?: parseFilenameFromUrl(url) ?: createFallbackFileName()

      val request = DownloadManager.Request(Uri.parse(url)).setTitle(name).setDestinationInExternalPublicDir(Environment.DIRECTORY_DOWNLOADS, name).setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED)

      downloadManager.enqueue(request)

    }
  }

}