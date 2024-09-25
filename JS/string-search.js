

; function matchAndSort(key, list) {

    var string_similarity = function (str1, str2) {
        if (str1.length && str2.length) {
            var str_1 = str1.toLowerCase().replace(/\s/g, "");
            var str_2 = str2.toLowerCase().replace(/\s/g, "");
            var ind1 = str_2.indexOf(str_1);
            var ind2 = str_1.indexOf(str_2);
            if (ind1 < 0 && ind2 < 0) return 999999;
            if (ind1 === 0) return 0;
            if (ind2 === 0) return 1;
            var maxLength = Math.max(str1.length, str2.length);
            return Math.min(ind1 < 0 ? maxLength : ind1, ind2 < 0 ? maxLength : ind2);
        }
        return 999999;
    }
    var result = [];
    for (var i = 0, j = list.length; i < j; i++) {
        var rank = string_similarity(key, list[i].Value);
        if (rank < 999999) {
            result.push({ rank: rank, object: list[i] });
        }
    }

    result.sort(function (a, b) {
        return a.rank - b.rank;
    });

    return result.map(function (obj) {
        return obj.object;
    });
}