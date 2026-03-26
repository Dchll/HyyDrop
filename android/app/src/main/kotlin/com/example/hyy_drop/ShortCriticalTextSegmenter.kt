package com.example.hyy_drop

object ShortCriticalTextSegmenter {
    private const val MAX_HAN_COUNT = 9
    private const val MAX_VISIBLE_LENGTH = 16

    private val strongBreakChars = setOf(
        '，', '。', '！', '？', '；', '：', '、',
        ',', '.', '!', '?', ';', ':', '\n',
    )
    private val weakBreakChars = setOf(' ', '-', '/', '|', '·', '~')

    fun segment(text: String?): List<String> {
        val source = text?.trim().orEmpty()
        if (source.isEmpty()) {
            return emptyList()
        }

        if (fits(source)) {
            return listOf(source)
        }

        val segments = mutableListOf<String>()
        val current = StringBuilder()
        for (token in tokenize(source)) {
            appendToken(segments, current, token)
        }
        flushCurrent(segments, current)

        return segments
            .map(::cleanSegment)
            .filter { it.isNotEmpty() }
    }

    private fun tokenize(text: String): List<String> {
        val tokens = mutableListOf<String>()
        val current = StringBuilder()

        for (char in text) {
            current.append(char)
            if (char in strongBreakChars || char in weakBreakChars) {
                tokens.add(current.toString())
                current.clear()
            }
        }

        if (current.isNotEmpty()) {
            tokens.add(current.toString())
        }

        return tokens
    }

    private fun appendToken(
        segments: MutableList<String>,
        current: StringBuilder,
        token: String,
    ) {
        val cleanedToken = cleanSegment(token)
        if (cleanedToken.isEmpty()) {
            return
        }

        val candidate = buildString {
            append(current)
            append(cleanedToken)
        }

        if (candidate.isNotEmpty() && fits(candidate)) {
            current.append(cleanedToken)
            return
        }

        flushCurrent(segments, current)

        if (fits(cleanedToken)) {
            current.append(cleanedToken)
            return
        }

        splitHard(cleanedToken).forEach { part ->
            if (part.isNotEmpty()) {
                segments.add(part)
            }
        }
    }

    private fun splitHard(text: String): List<String> {
        val parts = mutableListOf<String>()
        val current = StringBuilder()

        for (char in text) {
            if (current.isNotEmpty() && !fits(current.toString() + char)) {
                parts.add(cleanSegment(current.toString()))
                current.clear()
            }
            current.append(char)
        }

        if (current.isNotEmpty()) {
            parts.add(cleanSegment(current.toString()))
        }

        return parts
    }

    private fun flushCurrent(
        segments: MutableList<String>,
        current: StringBuilder,
    ) {
        if (current.isEmpty()) {
            return
        }

        val value = cleanSegment(current.toString())
        if (value.isNotEmpty()) {
            segments.add(value)
        }
        current.clear()
    }

    private fun fits(text: String): Boolean {
        val effective = trimIgnoredSuffix(text)
        if (effective.isEmpty()) {
            return true
        }

        return effective.length <= MAX_VISIBLE_LENGTH &&
            countHan(effective) <= MAX_HAN_COUNT
    }

    private fun cleanSegment(text: String): String {
        return text.trim()
    }

    private fun trimIgnoredSuffix(text: String): String {
        return text.trimEnd { char ->
            char.isWhitespace() || isPunctuation(char)
        }.trim()
    }

    private fun countHan(text: String): Int {
        return text.count(::isHan)
    }

    private fun isHan(char: Char): Boolean {
        return Character.UnicodeScript.of(char.code) == Character.UnicodeScript.HAN
    }

    private fun isPunctuation(char: Char): Boolean {
        return when (Character.getType(char)) {
            Character.CONNECTOR_PUNCTUATION.toInt(),
            Character.DASH_PUNCTUATION.toInt(),
            Character.START_PUNCTUATION.toInt(),
            Character.END_PUNCTUATION.toInt(),
            Character.OTHER_PUNCTUATION.toInt(),
            Character.INITIAL_QUOTE_PUNCTUATION.toInt(),
            Character.FINAL_QUOTE_PUNCTUATION.toInt() -> true
            else -> false
        }
    }
}
