class Point {
  double x, y;
  public Point(int X, int Y) {
    set(X, Y);
  }
  public Point(double X, double Y) {
    set(X, Y);
  }
  public void set(double X, double Y) {
    x = X;
    y = Y;
  }
  public double dist(Point other) {
    return Math.sqrt(Math.pow(x - other.x, 2) + Math.pow(y - other.y, 2));
  }
  public Point scale(double factor) {
    return new Point(x * factor, y * factor);
  }
  public Point add(Point other) {
    return new Point(x + other.x, y + other.y);
  }
  public double mag() {
    return Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2));
  }
  public JSONObject dumpPoint() {
    JSONObject _ = new JSONObject();
    _.setDouble("x", x);
    _.setDouble("y", y);
    return _;
  }
}
