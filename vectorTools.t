dataIsNotCollection(obj) {
    if (obj == nil) return true;
    return !obj.ofKind(Collection);
}

convertToVector(obj) {
    if (obj == nil) return new Vector();
    if (obj.ofKind(Vector)) return obj;
    if (obj.ofKind(List)) return new Vector(obj);
    local ret = new Vector(1);
    ret.append(obj);
    return ret;
}

dumpVectorAIntoB(a, b, unique?) {
    if (a == nil) return;
    if (!b.ofKind(Vector)) {
        throw new Exception('Destination b is not a true Vector!');
    }
    if (dataIsNotCollection(a)) {
        if (unique) b.appendUnique(a);
        else b.append(a);
        return;
    }
    for (local i = 1; i <= a.length; i++) {
        if (unique) b.appendUnique(a[i]);
        else b.append(a[i]);
    }
}

cloneVector(vec, unique?) {
    local clone = new Vector(vec.length);
    dumpVectorAIntoB(vec, clone, unique);
    return clone;
}

fuseVectors(a, b, unique?) {
    local aNCol = dataIsNotCollection(a);
    local bNCol = dataIsNotCollection(b);
    local aLen = aNCol ? 1 : a.length;
    local bLen = bNCol ? 1 : b.length;

    local repo = new Vector(aLen + bLen);

    if (a != nil) {
        if (aNCol) {
            if (unique) repo.appendUnique(a);
            else repo.append(a);
        }
        else {
            dumpVectorAIntoB(a, repo, unique);
        }
    }

    if (b != nil) {
        if (bNCol) {
            if (unique) repo.appendUnique(b);
            else repo.append(b);
        }
        else {
            dumpVectorAIntoB(b, repo, unique);
        }
    }

    return repo;
}

clearVector(vec) {
    if (vec.length == 0) return;
    vec.removeRange(1, -1);
}