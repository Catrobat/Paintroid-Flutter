package org.catrobat.paintroid

import android.content.Context
import android.net.Uri
import com.esotericsoftware.kryo.Kryo
import com.esotericsoftware.kryo.io.Input
import com.esotericsoftware.kryo.io.Output
import java.io.InputStream
import org.catrobat.paintroid.model.Layer

import org.catrobat.paintroid.command.serialization.VersionSerializer
import org.catrobat.paintroid.command.Command
import org.catrobat.paintroid.command.implementation.CompositeCommand
import org.catrobat.paintroid.command.serialization.CompositeCommandSerializer
import org.catrobat.paintroid.command.serialization.DataStructuresSerializer
import org.catrobat.paintroid.model.CommandManagerModel
import org.catrobat.paintroid.command.serialization.CommandManagerModelSerializer
import org.catrobat.paintroid.command.implementation.SetDimensionCommand
import org.catrobat.paintroid.command.implementation.SprayCommand
import org.catrobat.paintroid.command.serialization.SetDimensionCommandSerializer
import org.catrobat.paintroid.command.serialization.SprayCommandSerializer
import org.catrobat.paintroid.command.serialization.PaintSerializer

import org.catrobat.paintroid.command.implementation.AddEmptyLayerCommand
import org.catrobat.paintroid.command.serialization.AddLayerCommandSerializer

import org.catrobat.paintroid.command.implementation.SelectLayerCommand
import org.catrobat.paintroid.command.serialization.SelectLayerCommandSerializer

import org.catrobat.paintroid.command.implementation.LoadCommand
import org.catrobat.paintroid.command.serialization.LoadCommandSerializer

import org.catrobat.paintroid.command.implementation.TextToolCommand
import org.catrobat.paintroid.command.serialization.TextToolCommandSerializer

import org.catrobat.paintroid.command.implementation.FillCommand
import org.catrobat.paintroid.command.serialization.FillCommandSerializer

import org.catrobat.paintroid.command.implementation.FlipCommand
import org.catrobat.paintroid.command.serialization.FlipCommandSerializer

import org.catrobat.paintroid.command.implementation.CropCommand
import org.catrobat.paintroid.command.serialization.CropCommandSerializer

import org.catrobat.paintroid.command.implementation.CutCommand
import org.catrobat.paintroid.command.serialization.CutCommandSerializer



import org.catrobat.paintroid.command.implementation.ResizeCommand
import org.catrobat.paintroid.command.serialization.ResizeCommandSerializer

import org.catrobat.paintroid.command.implementation.RotateCommand
import org.catrobat.paintroid.command.serialization.RotateCommandSerializer
import org.catrobat.paintroid.command.implementation.ResetCommand
import org.catrobat.paintroid.command.serialization.ResetCommandSerializer


import org.catrobat.paintroid.command.implementation.ReorderLayersCommand
import org.catrobat.paintroid.command.serialization.ReorderLayersCommandSerializer

import org.catrobat.paintroid.command.implementation.RemoveLayerCommand
import org.catrobat.paintroid.command.serialization.RemoveLayerCommandSerializer



import org.catrobat.paintroid.command.implementation.MergeLayersCommand
import org.catrobat.paintroid.command.serialization.MergeLayersCommandSerializer

import org.catrobat.paintroid.command.implementation.PathCommand
import org.catrobat.paintroid.command.serialization.PathCommandSerializer


import org.catrobat.paintroid.command.serialization.SerializablePath

import org.catrobat.paintroid.command.implementation.LoadLayerListCommand
import org.catrobat.paintroid.command.serialization.LoadLayerListCommandSerializer


import org.catrobat.paintroid.command.implementation.GeometricFillCommand
import org.catrobat.paintroid.command.serialization.GeometricFillCommandSerializer


import org.catrobat.paintroid.command.implementation.ClipboardCommand
import org.catrobat.paintroid.command.serialization.ClipboardCommandSerializer


import org.catrobat.paintroid.command.serialization.SerializableTypeface


import org.catrobat.paintroid.command.implementation.PointCommand
import org.catrobat.paintroid.command.serialization.PointCommandSerializer


import org.catrobat.paintroid.command.serialization.BitmapSerializer


import org.catrobat.paintroid.command.implementation.SmudgePathCommand
import org.catrobat.paintroid.command.serialization.SmudgePathCommandSerializer


//import org.catrobat.paintroid.command.implementation.SmudgePathCommand
import org.catrobat.paintroid.colorpicker.ColorHistory
import org.catrobat.paintroid.command.serialization.ColorHistorySerializer



import org.catrobat.paintroid.command.implementation.ClippingCommand
import org.catrobat.paintroid.command.serialization.ClippingCommandSerializer


import org.catrobat.paintroid.command.implementation.LayerOpacityCommand
import org.catrobat.paintroid.command.serialization.LayerOpacityCommandSerializer

import android.graphics.Paint
import android.graphics.Point
import android.graphics.PointF
import android.graphics.RectF
import android.graphics.Bitmap

import android.content.ContentResolver
import android.content.ContentUris
import android.content.ContentValues


import org.catrobat.paintroid.tools.drawable.HeartDrawable
import org.catrobat.paintroid.tools.drawable.OvalDrawable
import org.catrobat.paintroid.tools.drawable.RectangleDrawable
import org.catrobat.paintroid.tools.drawable.ShapeDrawable
import org.catrobat.paintroid.tools.drawable.StarDrawable


class FileReader(private val context : Context)
{
    private lateinit var activityContext: Context // MAYBE CAUSE A CRASH
    private val kryo = Kryo()
    private val registerMap = LinkedHashMap<Class<*>, VersionSerializer<*>?>()
    companion object {
        const val MAGIC_VALUE = "CatrobatImg"
        const val CURRENT_IMAGE_VERSION = 2 // handle 1 look up how to do it in the native verson
    }
    init {
        setRegisterMapVersion(CURRENT_IMAGE_VERSION)
        registerClasses()
    }
  /*  fun readFromFile(uri: String): CatrobatFileContent{
        var commandModel: CommandManagerModel
        var colorHistory: ColorHistory? = null
    }*/
  private fun setRegisterMapVersion(version: Int) {
      // Only add new classes at the end
      // because Kryo assigns an ID to each class
      with(registerMap) {
          put(Command::class.java, null)
          put(CompositeCommand::class.java, CompositeCommandSerializer(version))
          put(FloatArray::class.java, DataStructuresSerializer.FloatArraySerializer(version))
          put(PointF::class.java, DataStructuresSerializer.PointFSerializer(version))
          put(Point::class.java, DataStructuresSerializer.PointSerializer(version))
          put(CommandManagerModel::class.java, CommandManagerModelSerializer(version))
          put(SetDimensionCommand::class.java, SetDimensionCommandSerializer(version))
          put(SprayCommand::class.java, SprayCommandSerializer(version))
          put(Paint::class.java, PaintSerializer(version, activityContext)) // maybe will cause a crash ?  activityContext is lateinnit
          put(AddEmptyLayerCommand::class.java, AddLayerCommandSerializer(version))
          put(SelectLayerCommand::class.java, SelectLayerCommandSerializer(version))
          put(LoadCommand::class.java, LoadCommandSerializer(version))
          put(TextToolCommand::class.java, TextToolCommandSerializer(version, activityContext))
          put(Array<String>::class.java, DataStructuresSerializer.StringArraySerializer(version))
          put(FillCommand::class.java, FillCommandSerializer(version))
          put(FlipCommand::class.java, FlipCommandSerializer(version))
          put(CropCommand::class.java, CropCommandSerializer(version))
          put(CutCommand::class.java, CutCommandSerializer(version))
          put(ResizeCommand::class.java, ResizeCommandSerializer(version))
          put(RotateCommand::class.java, RotateCommandSerializer(version))
          put(ResetCommand::class.java, ResetCommandSerializer(version))
          put(ReorderLayersCommand::class.java, ReorderLayersCommandSerializer(version))
          put(RemoveLayerCommand::class.java, RemoveLayerCommandSerializer(version))
          put(MergeLayersCommand::class.java, MergeLayersCommandSerializer(version))
          put(PathCommand::class.java, PathCommandSerializer(version))
          put(SerializablePath::class.java, SerializablePath.PathSerializer(version))
          put(SerializablePath.Move::class.java, SerializablePath.PathActionMoveSerializer(version))
          put(SerializablePath.Line::class.java, SerializablePath.PathActionLineSerializer(version))
          put(SerializablePath.Quad::class.java, SerializablePath.PathActionQuadSerializer(version))
          put(SerializablePath.Rewind::class.java, SerializablePath.PathActionRewindSerializer(version))
          put(LoadLayerListCommand::class.java, LoadLayerListCommandSerializer(version))
          put(GeometricFillCommand::class.java, GeometricFillCommandSerializer(version))
          put(HeartDrawable::class.java, GeometricFillCommandSerializer.HeartDrawableSerializer(version))
          put(OvalDrawable::class.java, GeometricFillCommandSerializer.OvalDrawableSerializer(version))
          put(RectangleDrawable::class.java, GeometricFillCommandSerializer.RectangleDrawableSerializer(version))
          put(StarDrawable::class.java, GeometricFillCommandSerializer.StarDrawableSerializer(version))
          put(ShapeDrawable::class.java, null)
          put(RectF::class.java, DataStructuresSerializer.RectFSerializer(version))
          put(ClipboardCommand::class.java, ClipboardCommandSerializer(version))
          put(SerializableTypeface::class.java, SerializableTypeface.TypefaceSerializer(version))
          put(PointCommand::class.java, PointCommandSerializer(version))
          put(SerializablePath.Cube::class.java, SerializablePath.PathActionCubeSerializer(version))
          put(Bitmap::class.java, BitmapSerializer(version))
          put(SmudgePathCommand::class.java, SmudgePathCommandSerializer(version))
          put(ColorHistory::class.java, ColorHistorySerializer(version))
          put(ClippingCommand::class.java, ClippingCommandSerializer(version))
          put(LayerOpacityCommand::class.java, LayerOpacityCommandSerializer(version))
      }
  }
    private fun registerClasses() {
        registerMap.forEach { (classRegister, serializer) ->
            val registration = kryo.register(classRegister)
            serializer?.let {
                registration.serializer = serializer
            }
        }
    }


}