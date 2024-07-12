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



import android.graphics.Point
import android.graphics.PointF
class FileReader(private val context : Context)
{
    private val kryo = Kryo()
    private val registerMap = LinkedHashMap<Class<*>, VersionSerializer<*>?>()
    companion object {
        const val MAGIC_VALUE = "CatrobatImg"
        const val CURRENT_IMAGE_VERSION = 2 // handle 1 look up how to do it in the native verson
    }
    init {
        setRegisterMapVersion(CURRENT_IMAGE_VERSION)
      //  registerClasses()
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
         /* put(SetDimensionCommand::class.java, SetDimensionCommandSerializer(version))
          put(SprayCommand::class.java, SprayCommandSerializer(version))
          put(Paint::class.java, PaintSerializer(version, activityContext))
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
     */ }
  }



}