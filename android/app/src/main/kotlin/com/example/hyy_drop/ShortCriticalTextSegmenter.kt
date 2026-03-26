package com.example.hyy_drop

object ShortCriticalTextSegmenter {
    fun segment(text: String?): List<String> {
        return text
            ?.lineSequence()
            ?.map(::cleanSegment)
            ?.filter { it.isNotEmpty() }
            ?.toList()
            ?: emptyList()
    }

    private fun cleanSegment(text: String): String {
        return text.trim()
    }
}
