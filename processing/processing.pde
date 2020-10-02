ArrayList<Point> samples = new ArrayList<Point>();
int clusters = 4;
int er = 0;
int iterations = -1, fps = 12, prec = 2;
ArrayList<Point> means = new ArrayList<Point>();
double loss = 0;
void setup() {
  size(800, 800);
  background(0);
  try {
    JSONObject config;
    try {
      config = loadJSONObject("config.json");
    } 
    catch (Exception e) {
      textSize(50);
      String err = "The application has encountered an error while finding `config.json` file in the current directory";
      text(err, 100, 100, 700, 700);
      er = 1;
      return;
    }
    if (!config.isNull("iterations")) iterations = config.getInt("iterations");
    if (!config.isNull("clusters")) clusters = config.getInt("clusters");
    if (!config.isNull("fps")) fps = config.getInt("fps");
    if (!config.isNull("precision")) prec = config.getInt("precision");
    JSONArray values;
    try {
      values = loadJSONArray("data/samples.json");
    } 
    catch (Exception e) {
      textSize(50);
      String err = "The application has encountered an error while finding `data/samples.json` file in the current directory";
      text(err, 100, 100, width - 100, height - 100);
      er = 1;
      return;
    }
    for (int i = 0; i < values.size(); ++i) {
      JSONArray point = values.getJSONArray(i);
      samples.add(new Point(point.getDouble(0), point.getDouble(1)));
    }
    for (int i = 0; i < clusters; ++i) {
      means.add(new Point(random(width), random(height)));
    }
    frameRate(fps);
  } 
  catch (Exception e) {
    textSize(50);
    String err = "Something Went Wrong, check the json files";
    text(err, 100, 100, 700, 700);
    er = 1;
    return;
  }
}

double round(double number, int pre) {
  return Math.round(number * Math.pow(10, pre)) / Math.pow(10, pre);
}

void draw() {
  if (er != 0) {
    noLoop();
    return;
  }
  background(0);
  text("" + round(loss, prec) + "", 1, height);
  print("" + loss + "\r");
  // Draw Static Assets
  for (int i = 0; i < samples.size(); ++i) {
    Point a = samples.get(i);
    fill(255);
    stroke(0);
    ellipse((float)a.x, (float)a.y, 5.0, 5.0);
  }
  ArrayList<Point> new_mean = new ArrayList<Point>();
  IntList fac = new IntList();
  for (int i = 0; i < means.size(); ++i) {
    Point a = means.get(i);
    stroke(0);
    fill(255, 0, 0);
    ellipse((float)a.x, (float)a.y, 10.0, 10.0);
    new_mean.add(new Point(0, 0));
    fac.append(0);
  }
  for (int i = 0; i < samples.size(); ++i) {
    int small = -1;
    double old_dist = height * width;
    for (int j = 0; j < means.size(); ++j) {
      double dist = means.get(j).dist(samples.get(i));
      if (dist < old_dist) {
        small = j;
        old_dist = dist;
      }
    }
    stroke(100, 100, 100);
    strokeWeight(1);
    line((float)means.get(small).x, (float)means.get(small).y, (float)samples.get(i).x, (float)samples.get(i).y);
    new_mean.set(small, new_mean.get(small).add(samples.get(i)));
    fac.set(small, fac.get(small) + 1);
  }
  loss = 0;
  for (int i = 0; i < means.size(); ++i) {
    Point _ = new_mean.get(i).scale((double)1/fac.get(i)).add(means.get(i)).scale(0.5);
    loss += means.get(i).add(_.scale(-1)).mag();
    means.set(i, _);
  }
  loss /= means.size();
  if (iterations == 0 || round(loss, prec) == 0) {
    noLoop();
    JSONArray output_means = new JSONArray();
    for (int i = 0; i < means.size(); ++i) {
      output_means.append(means.get(i).dumpPoint());
    }
    print("\nDumping\n");
    saveJSONArray(output_means, "output.json");
  } else {
    iterations = (iterations != -1)? (iterations - 1) : iterations;
  }
}
