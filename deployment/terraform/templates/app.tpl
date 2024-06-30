---
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: ${JOB_ENV}
  name: app-secret
  labels:
    app: postgres
    env: ${JOB_ENV}
data:
  POSTGRES_DB: "${POSTGRES_DB}"
  POSTGRES_USER: "${POSTGRES_USER}"
  POSTGRES_PASSWORD: "${POSTGRES_PASSWORD}"
  POSTGRES_HOST: "postgres"
  POSTGRES_PORT: ${POSTGRES_PORT}
  BOT_TOKEN: "${BOT_TOKEN}-${JOB_ENV}"


apiVersion: apps/v1
kind: Deployment
metadata:
  namespace: ${JOB_ENV}
  name: bot
spec:
  replicas: 1
  selector:
    matchLabels:
      app: bot
      env: ${JOB_ENV}
  template:
    metadata:
      labels:
        app: bot
        env: ${JOB_ENV}
    spec:
      containers:
        - name: bot
          image: '${REPO}/lek-x/${IMAGE_NAME}:${VER}'
          imagePullPolicy: IfNotPresent
          ports:
            - containerPort: 88
          envFrom:
            - configMapRef:
                name: app-secret

---
apiVersion: v1
kind: Service
metadata:
  namespace: ${JOB_ENV}
  name: bot-svc
  env: ${JOB_ENV}
spec:
  type: ClusterIP
  selector:
    app: bot
    env: ${JOB_ENV}
  ports:
    - port: 88
    - port: 8443

---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  namespace: ${JOB_ENV}
  name: bot-ingress
  annotations:
    traefik.ingress.kubernetes.io/router.entrypoints: bot
spec:
  rules:
    - host: bot.$IP.sslip.io
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: bot-svc
                env: ${JOB_ENV}
                port:
                  number: 88
