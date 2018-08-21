class MathUtil

    def self.algo
        puts "hola mami"
    end

    def self.arc_hav(x)
        return 2.0 * Math.asin(Math.sqrt(x))
    end

    def self.hav(x) 
        sin_alf = Math.sin(x * 0.5);
        return sin_alf * sin_alf;
    end

    def self.have_distance(lat1, lat2, d_lng)
        return hav(lat1 - lat2) + hav(d_lng) * Math.cos(lat1) * Math.cos(lat2);
    end

    def self.to_radiams(x)
        x * Math::PI / 180 
    end

    def self.to_degree(x)
        x * 180 / Math::PI
    end


end