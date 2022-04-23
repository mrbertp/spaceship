float[][] vectomat(PVector u){
  
  float[][] mat = new float[][]{
    {u.x},
    {u.y},
    {u.z}
  };
  return mat;
}

PVector mattovec(float[][] m){

  PVector v = new PVector(
    m[0][0],
    m[1][0],
    m[2][0]
  );
  return v;
}

float[][] matmult(float[][] matA, float[][] matB) {

  float[][] result = new float[matA.length][matB[0].length];
  for (int i = 0; i < matA.length; i++) {
    for (int k = 0; k < matB[0].length; k++){
      float sum = 0;
      for (int j = 0; j < matA[0].length; j++) {
        sum += matA[i][j] * matB[j][k];
      }
      result[i][k] = sum;
    }
  }
  return result;
}

PVector rot(float ax, float ay, float az, PVector u) {

  float[][] rotX = new float[][]{
    {1, 0, 0},
    {0, cos(radians(ax)), -sin(radians(ax))},
    {0, sin(radians(ax)), cos(radians(ax))}
  };

  float[][] rotY = new float[][]{
    {cos(radians(ay)), 0, sin(radians(ay))},
    {0, 1, 0},
    {-sin(radians(ay)), 0, cos(radians(ay))}
  };

  float[][] rotZ = new float[][]{
    {cos(radians(az)), -sin(radians(az)), 0},
    {sin(radians(az)), cos(radians(az)), 0},
    {0, 0, 1}
  };
  
  float[][] rotmat = matmult(matmult(rotX, rotY), rotZ);
  float[][] rotated = matmult(rotmat, vectomat(u));
  PVector v = mattovec(rotated);
  return v;
}
