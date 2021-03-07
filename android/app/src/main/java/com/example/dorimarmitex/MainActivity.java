package com.example.dorimarmitex;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import java.util.ArrayList;
import java.util.List;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Typeface;
import androidx.core.content.res.ResourcesCompat;
import java.text.SimpleDateFormat;
import java.util.Date;
import android.util.Log;
import java.lang.Math;


public class MainActivity extends FlutterActivity {

  private static final String CHANNEL = "flutter.dev/dorimarmitex";
  private List<Item> items = new ArrayList<>(); 
  private List<Item> tipo0 = new ArrayList<>(); 
  private List<Item> tipo1 = new ArrayList<>();
  private List<Item> tipo2 = new ArrayList<>();

  private int x0 = 100;
  private int y0 = 1200;
  private int x1 = 550;
  private int y1 = 1200;
  private int qtd0 = 0;
  private int qtd1 = 0;
  private Canvas canvas;
  private Paint paint;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    
    this.items.clear();

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
      new MethodCallHandler() {
        @Override
        public void onMethodCall(MethodCall call, Result result) {
          
          if (call.method.equals("addItems")) {

            String nome = call.argument("nome");
            int tipo = call.argument("tipo");
            
            int size = addItems(nome, tipo);
            result.success("Sucesso " + size);

          } else if(call.method.equals("writeImage")){

            String resultado = writeImage();
            result.success("Sucesso Escrita " + resultado);
            //result.error("UNAVAILABLE", "Battery level not available.", null);
            
          } else {
            result.notImplemented();
          }


        }
    });

  }

  private int addItems(String nome, int tipo){
    Item novo = new Item(nome, tipo);

    if(tipo == 0)
      this.tipo0.add(novo);
    else if(tipo == 1)
      this.tipo1.add(novo);
    else if(tipo == 2)
      this.tipo2.add(novo);
    
    return this.items.size();
  }

  private String writeImage() {

    this.items.addAll(this.tipo0);
    this.items.addAll(this.tipo1);
    this.items.addAll(this.tipo2);

    BitmapFactory.Options options = new BitmapFactory.Options();
    options.inScaled = false;
    options.inMutable = true;

    Bitmap bitmap = BitmapFactory.decodeResource(getResources(), R.drawable.cardapio_img, options);
    Typeface font = ResourcesCompat.getFont(this, R.font.bebas_neue_regular);
    this.canvas = new Canvas(bitmap);

    this.paint = new Paint();
    int color = Color.rgb(90, 28, 31);
    paint.setColor(color);
    paint.setTextSize(52);
    paint.setFakeBoldText(true);
    paint.setTypeface(font);

    for(int i = 0; i < items.size(); i++){

        Item item = items.get(i);

        drawText(item.getNome(), item.getTipo());
    }

    this.qtd0 = 0;
    this.qtd1 = 0;
    this.items.clear();
    this.tipo0.clear();
    this.tipo1.clear();
    this.tipo2.clear();

    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
    String currentDateandTime = sdf.format(new Date());

    new ImageSaver(getApplicationContext()).
            setFileName("Cardapio-"+currentDateandTime+".png").
            setExternal(true).
            setDirectoryName("Cardapios").
            save(bitmap);

    return "Finalizado";
  }


  private void drawText(String name, int type) {

    int x;
    int y;
    int qtd;
    int sum = 60;
    
    if(type == 0){
      x = this.x0;
      y = this.y0;
      qtd = this.qtd0;
      
    } else {
      x = this.x1;
      y = this.y1;
      qtd = this.qtd1;

      if(type == 2){
        sum = 75;
      }

    }

    if(name.length() <= 20) {
      // Fits in a row

      name = buildName(name, type, 1);
      this.canvas.drawText(name, x, y + (qtd * sum), this.paint);
      qtd++;

    } else {

      String[] splited = name.split("\\s+");
      String result = "";
      boolean first = true;

      for(int i = 0; i < splited.length; i++){

        if( (result.length() + splited[i].length()) <= 20) {
        
          result += splited[i] + " ";

          if( (splited.length - 1) == i) {

            if(first){
              name = buildName(result, type, 1);
              this.canvas.drawText(name, x, y + (qtd * sum), this.paint);
              first = false;
            } else {
              name = buildName(result, type, 2);
              this.canvas.drawText(name, x+25, y + (qtd * sum), this.paint);
            }
            qtd++;
          }

        } else if(splited[i].length() > 20) {

          int splitInit = 0;
          String part = splited[i].substring(splitInit, splitInit + 20);
          int limit = (int) Math.ceil((double)splited[i].length() / 20);

          for(int j = 0; j <= limit; j++) {

            if(first) {
              int partToWrite = type == 2? 0 : 1;
              name = buildName(part, type, partToWrite);
              this.canvas.drawText(name, x, y + (qtd * sum), this.paint);
              first = false;
            } else {
              name = buildName(part, type, 3);
              this.canvas.drawText(name, x+25, y + (qtd * sum), this.paint);
            }

            splitInit += 20;
            part = splited[i].substring(splitInit, splitInit + 20);
          }

        } else {

          if(first) {
            int partToWrite = type == 2? 0 : 1;
            name = buildName(result, type, partToWrite);
            this.canvas.drawText(name, x, y + (qtd * sum), this.paint);
            first = false;
          } else {
            name = buildName(result, type, 3);
            this.canvas.drawText(name, x+25, y0 + (qtd * sum), this.paint);
          }
          
          qtd++;
          result = splited[i] + " ";

          // Se a palavra que falta for a ultima
          if( (splited.length - 1) == i) {
            name = buildName(result, type, 2);
            this.canvas.drawText(name, x+25, y + (qtd * sum), this.paint);
            qtd++;
          }
        }
            
      }

    }

    if(type == 0){
      this.qtd0 = qtd;
    } else {
      this.qtd1 = qtd;
    }

  }
  
  private String buildName(String name, int type, int part) {

    String nameDraw = name;

    if(type == 2) {

      // part
      // 0 = only front
      // 1 = complete
      // 2 = only back
      // other case just return the name

      switch(part){

        case 0:
          nameDraw = "** " + nameDraw;
          break;

        case 1:
          nameDraw = "** " + nameDraw + " **";
          break;

        case 2:
          nameDraw = nameDraw + " **";
          break;

      }

    } else {

      // Other type only insert in part 1
      if(part == 1){
        nameDraw = "• " + nameDraw;
      }
        
    }


    return nameDraw;
  }


}
