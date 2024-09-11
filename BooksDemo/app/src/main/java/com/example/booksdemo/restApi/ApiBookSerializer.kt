package com.example.booksdemo.restApi

import kotlinx.serialization.KSerializer
import kotlinx.serialization.SerializationException
import kotlinx.serialization.descriptors.SerialDescriptor
import kotlinx.serialization.descriptors.buildClassSerialDescriptor
import kotlinx.serialization.descriptors.element
import kotlinx.serialization.encoding.CompositeDecoder
import kotlinx.serialization.encoding.Decoder
import kotlinx.serialization.encoding.Encoder

object ApiBookSerializer : KSerializer<ApiBook> {
    override val descriptor: SerialDescriptor = buildClassSerialDescriptor("ApiBook") {
        element<Int>("id")
        element<String>("title")
        element<String>("author")
        element<String>("description")
        element<String>("cover")
    }

    override fun serialize(encoder: Encoder, value: ApiBook) {
        val composite = encoder.beginStructure(descriptor)
        composite.encodeIntElement(descriptor, 0, value.id)
        composite.encodeStringElement(descriptor, 1, value.title)
        composite.encodeStringElement(descriptor, 2, value.author)
        composite.encodeStringElement(descriptor, 3, value.description)
        composite.encodeStringElement(descriptor, 4, value.coverImageUrl)
        composite.endStructure(descriptor)
    }

    override fun deserialize(decoder: Decoder): ApiBook {
        val dec = decoder.beginStructure(descriptor)
        var id = 0
        var title = ""
        var author = ""
        var description = ""
        var coverImageUrl = ""

        loop@ while (true) {
            when (val index = dec.decodeElementIndex(descriptor)) {
                0 -> id = dec.decodeIntElement(descriptor, index)
                1 -> title = dec.decodeStringElement(descriptor, index)
                2 -> author = dec.decodeStringElement(descriptor, index)
                3 -> description = dec.decodeStringElement(descriptor, index)
                4 -> coverImageUrl = dec.decodeStringElement(descriptor, index)
                CompositeDecoder.DECODE_DONE -> break@loop
                else -> throw SerializationException("Unknown index $index")
            }
        }
        dec.endStructure(descriptor)

        return ApiBook(id, title, author, description, coverImageUrl + "?lock=${id}")
    }
}