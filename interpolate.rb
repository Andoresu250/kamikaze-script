load  "math_util.rb" 

class LatLng
    def initialize(lat, lng)  
        # Instance variables  
        @lat = lat  
        @lng = lng  
    end 

    def lat
        @lat
    end

    def lng
        @lng
    end

    def to_s
        "{lat: #{@lat}, lng: #{@lng}},"
    end
end

def compute_angle_between(from, to)
    lat1 = MathUtil::to_radiams(from.lat)
    lng1 = MathUtil::to_radiams(from.lng)
    lat2 = MathUtil::to_radiams(to.lat)
    lng2 = MathUtil::to_radiams(to.lng)
    return distance_radians(lat1, lng1, lat2, lng2)
end

def distance_radians(lat1, lng1, lat2, lng2)
    MathUtil::arc_hav(MathUtil::have_distance(lat1, lat2, lng1 - lng2))
end

def interpolate(from, to, fraction) 
    fromLat = MathUtil::to_radiams(from.lat);
    fromLng = MathUtil::to_radiams(from.lng);
    toLat = MathUtil::to_radiams(to.lat);
    toLng = MathUtil::to_radiams(to.lng);
    cosFromLat = Math.cos(fromLat);
    cosToLat = Math.cos(toLat);
    angle = compute_angle_between(from, to);
    sinAngle = Math.sin(angle);
    if (sinAngle < 1.0E-6) 
        return from;
    else 
        a = Math.sin((1.0 - fraction) * angle) / sinAngle;
        b = Math.sin(fraction * angle) / sinAngle;
        x = a * cosFromLat * Math.cos(fromLng) + b * cosToLat * Math.cos(toLng);
        y = a * cosFromLat * Math.sin(fromLng) + b * cosToLat * Math.sin(toLng);
        z = a * Math.sin(fromLat) + b * Math.sin(toLat);
        lat = Math.atan2(z, Math.sqrt(x * x + y * y));
        lng = Math.atan2(y, x);
        return LatLng.new(MathUtil::to_degree(lat), MathUtil::to_degree(lng));
    end
end
#                       y           x
esquina1 = LatLng.new(11.024144, -74.845256)
esquina2 = LatLng.new(10.921062, -74.845256)
esquina3 = LatLng.new(10.921062, -74.767297)
esquina4 = LatLng.new(11.024144, -74.767297)

row0 = []
col0 = []

points = []

cuadrantes = {}

(1..5).each do |i|
    fraction = i.to_f/5.to_f
    row0 << interpolate(esquina1, esquina4, fraction)
    col0 << interpolate(esquina1, esquina2, fraction)
end

count = 0;
rown = []
puts row0.size
(0..col0.size - 1).each do |i|
    # rown << col0[i]
    (0..row0.size - 1).each do |j|     

        if count == 0
            reference = esquina1
        else            
            reference = col0[i - 1]
        end
        if j == 0
            p0 =  reference            
            p1 =  row0[j]            
            p2 =  col0[i]            
            p3 =  LatLng.new(p2.lat, p1.lng)        
        else                        
            previus = cuadrantes[(count - 1).to_s]
            p0 =  row0[j - 1]
            p1 =  row0[j]            
            p2 =  previus[:p3]            
            p3 =  LatLng.new(p2.lat, p1.lng)                            
        end 

        rown << p3

        puts "cuadrante #{count}"
        puts ""
        puts p0
        puts p1
        puts p2
        puts p3
        puts ""

        cuadrantes[count.to_s] = {
                "p0":  p0,
                "p1":  p1,
                "p2":  p2,
                "p3":  p3
            }

        count += 1
    end
    row0 = rown
    # puts "1: #{rown.size}"
    rown = []
    # puts "2: #{rown.size}"
    
end

row0.each do |point1|
    col0.each do |point2|
        points << LatLng.new(point2.lat, point1.lng)
    end
end

points += row0
points += col0

# puts points


